#!/bin/sh

if [ -z ${SQITCH_USERNAME+x} ]; then
  # For the local machine use a default `dbadmin` username and a randomly
  # generated password
  pushd ..
  echo dbadmin | fnox set --config fnox.local.toml --profile default --provider age SQITCH_USERNAME
  openssl rand -hex 100 | fnox set --config fnox.local.toml --profile default --provider age SQITCH_PASSWORD
  popd
fi
