-- Revert scout-badges-bootstrap:admin_user from pg

BEGIN;

DROP OWNED BY scout_badges_db_admin;
DROP ROLE scout_badges_db_admin;

COMMIT;
