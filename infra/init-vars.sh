#!/bin/sh

# AWS secrets manager stores the password for the Postgres admin and the ID for
# the secret is an output from Terraform (along with the database URL)
tf_output=$(terraform output -json)
aws_rds_sm_key=$(echo $tf_output | jq '.postgres_secrets_manager_entry.value' --raw-output)
rds_endpoint=$(echo $tf_output | jq '.postgres_instance_endpoint.value' --raw-output)
rds_host=$(echo $rds_endpoint | sed -e 's/:.*//')
rds_port=$(echo $rds_endpoint | sed -e 's/.*://')
rds_admin=$(aws secretsmanager get-secret-value --secret-id $aws_rds_sm_key | jq ".SecretString | fromjson")
# Set the username, password, and database URL in the `src/database` directory
pushd $(git rev-parse --show-toplevel)/src/database
fnox set --config fnox.local.toml --description "Username of Postgres admin account" --profile $MISE_ENV --provider age PGUSER
fnox set --config fnox.local.toml --description "Password for Postgres admin account" --profile $MISE_ENV --provider age PGPASSWORD
fnox set --config fnox.local.toml --description "Address of Postgres database server" --profile $MISE_ENV --provider age PGHOST
fnox set --config fnox.local.toml --description "Port number of Postgres database server" --profile $MISE_ENV --provider age PGPORT
fnox set --config fnox.local.toml --description "Database name" --profile $MISE_ENV --provider age PGDATABASE
fnox set --config fnox.local.toml --description "Sqitch target" --profile $MISE_ENV --provider age SQITCH_TARGET
echo $rds_admin | jq '.username' --raw-output | fnox set --config fnox.local.toml --profile $MISE_ENV --provider age PGUSER
echo $rds_admin | jq '.password' --raw-output | fnox set --config fnox.local.toml --profile $MISE_ENV --provider age PGPASSWORD
echo $rds_host | fnox set --config fnox.local.toml --profile $MISE_ENV --provider age PGHOST
echo $rds_port | fnox set --config fnox.local.toml --profile $MISE_ENV --provider age PGPORT
echo "postgresdev" | fnox set --config fnox.local.toml --profile $MISE_ENV --provider age PGDATABASE
echo "db:pg://$rds_host:$rds_port/postgresdev" | fnox set --config fnox.local.toml --profile $MISE_ENV --provider age SQITCH_TARGET
popd
