#!/bin/sh

if [ ! -d pg ]; then
  echo $PGPASSWORD > .pgpass
  initdb -U $PGUSER --pwfile .pgpass pg
  rm .pgpass
fi
