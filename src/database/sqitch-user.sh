#!/bin/sh
export SQITCH_FULLNAME=$(git config get user.name)
export SQITCH_EMAIL=$(git config get user.email)
