-- Revert scout-badges-bootstrap:app_schema from pg

BEGIN;

DROP SCHEMA scout_badges;

COMMIT;
