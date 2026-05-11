#!/bin/sh

host=$(echo $SQITCH_TARGET | sed -e 's/db:pg:/postgresql:/')
PGPASSWORD=$SQITCH_PASSWORD psql --file=scripts/initdb.sql -U $SQITCH_USERNAME $host
