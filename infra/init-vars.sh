#!/bin/sh

# AWS secrets manager stores the password for the Postgres admin and the ID for
# the secret is an output from Terraform (along with the database URL)
tf_output=$(terraform output -json)
aws_rds_sm_key=$(echo $tf_output | jq '.postgres_secrets_manager_entry.value' --raw-output)
rds_endpoint="db:pg://$(echo $tf_output | jq '.postgres_instance_endpoint.value' --raw-output)/postgresdev"
rds_admin=$(aws secretsmanager get-secret-value --secret-id $aws_rds_sm_key | jq ".SecretString | fromjson")
# Set the username, password, and database URL in the `src/database` directory
pushd $(git rev-parse --show-toplevel)/src/database
echo $rds_admin | jq '.username' --raw-output | fnox set --config fnox.local.toml --profile $MISE_ENV --provider age SQITCH_USERNAME
echo $rds_admin | jq '.password' --raw-output | fnox set --config fnox.local.toml --profile $MISE_ENV --provider age SQITCH_PASSWORD
echo $rds_endpoint | fnox set --config fnox.local.toml --profile $MISE_ENV --provider age SQITCH_TARGET
popd
