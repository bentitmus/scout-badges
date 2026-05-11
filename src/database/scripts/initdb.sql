BEGIN;

SET lock_timeout = '1s';
SET statement_timeout = '5s';

REVOKE ALL ON SCHEMA public FROM PUBLIC;
-- By default `PUBLIC` has `EXECUTE` as the only permission, but we want to
-- explicitly grant this to each role
-- This is for all functions created by the admin
ALTER DEFAULT PRIVILEGES
  REVOKE ALL ON FUNCTIONS FROM PUBLIC;
ALTER DEFAULT PRIVILEGES
  REVOKE ALL ON SCHEMAS FROM PUBLIC;

CREATE SCHEMA IF NOT EXISTS scout_badges;

COMMIT;
