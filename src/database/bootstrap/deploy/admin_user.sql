-- Deploy scout-badges-bootstrap:admin_user to pg

BEGIN;

SET lock_timeout = '1s';
SET statement_timeout = '5s';
CREATE ROLE scout_badges_db_admin;

COMMIT;
