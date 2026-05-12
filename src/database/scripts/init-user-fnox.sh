#!/bin/sh

if [ -z ${PGPASSWORD+x} ]; then
  # For the local machine use a randomly generated password
  openssl rand -hex 100 | fnox set --config fnox.local.toml --profile default --provider age PGPASSWORD
fi
