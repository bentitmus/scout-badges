-- Revert scout-badges-bootstrap:admin_user from pg

BEGIN;

SET lock_timeout = '1s';
SET statement_timeout = '5s';
DROP OWNED BY scout_badges_db_admin;
DROP ROLE scout_badges_db_admin;

COMMIT;
