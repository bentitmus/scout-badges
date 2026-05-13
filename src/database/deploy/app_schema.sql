-- Deploy scout-badges:app_schema to pg

BEGIN;

SET lock_timeout = '1s';
SET statement_timeout = '5s';

CREATE SCHEMA scout_badges;

COMMIT;
