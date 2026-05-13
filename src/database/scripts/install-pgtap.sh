#!/bin/sh

export PGUSER=postgres
export PGHOST=localhost
export PGPORT=5432
export PGDATA=$1
curl https://api.pgxn.org/dist/pgtap/1.3.4/pgtap-1.3.4.zip --output pgtap-1.3.4.zip
unzip pgtap-1.3.4.zip
cd pgtap-1.3.4
make
make install
pg_ctl start
make installcheck
pg_ctl stop
cd ..
rm -rf pgtap-1.3.4*
