-- Deploy scout-badges-bootstrap:admin_user to pg

BEGIN;

CREATE ROLE scout_badges_db_admin;

COMMIT;
