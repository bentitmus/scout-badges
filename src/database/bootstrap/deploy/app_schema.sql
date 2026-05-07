-- Deploy scout-badges-bootstrap:app_schema to pg

BEGIN;

CREATE SCHEMA scout_badges AUTHORIZATION scout_badges_db_admin;

COMMIT;
