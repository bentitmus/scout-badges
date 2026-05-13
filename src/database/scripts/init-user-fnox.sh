#!/bin/sh

if [ -z ${PGPASSWORD+x} ]; then
  # For the local machine use a randomly generated password
  fnox set --config fnox.local.toml --description "Password for Postgres admin account" --profile default --provider age PGPASSWORD
  openssl rand -hex 100 | fnox set --config fnox.local.toml --profile default --provider age PGPASSWORD
fi
