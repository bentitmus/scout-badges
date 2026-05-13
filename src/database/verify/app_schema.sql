-- Verify scout-badges:app_schema on pg

BEGIN;

SELECT pg_catalog.has_schema_privilege('scout_badges', 'usage');

ROLLBACK;
