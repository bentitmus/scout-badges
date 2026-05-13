-- Revert scout-badges:app_schema from pg

BEGIN;

SET lock_timeout = '1s';
SET statement_timeout = '5s';

DROP SCHEMA scout_badges;

COMMIT;
