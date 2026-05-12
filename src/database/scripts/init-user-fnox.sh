#!/bin/sh

if [ -z ${PGUSER+x} ]; then
  # For the local machine use a default `dbadmin` username and a randomly
  # generated password
  echo dbadmin | fnox set --config fnox.local.toml --profile default --provider age PGUSER
  openssl rand -hex 100 | fnox set --config fnox.local.toml --profile default --provider age PGPASSWORD
fi
