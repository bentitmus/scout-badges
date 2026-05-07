-- Deploy scout-badges-bootstrap:default_permissions to pg

BEGIN;

REVOKE ALL ON SCHEMA public FROM PUBLIC;
-- By default `PUBLIC` has `EXECUTE` as the only permission, but we want to
-- explicitly grant this to each role
-- This is for all functions created by `scout_badges_db_admin`
ALTER DEFAULT PRIVILEGES FOR ROLE scout_badges_db_admin
  REVOKE ALL ON FUNCTIONS FROM PUBLIC;
ALTER DEFAULT PRIVILEGES
  REVOKE ALL ON SCHEMAS FROM PUBLIC;

COMMIT;
