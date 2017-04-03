CREATE OR REPLACE FUNCTION identity."role.fetch"(
  "@isPublic" boolean
) RETURNS TABLE (
  "roleId" INTEGER,
  "name" VARCHAR(10)
)
AS
$body$
BEGIN
  RETURN QUERY
  SELECT
    r."roleId", r."name"
  FROM
     identity."role" r
  WHERE
    ("@isPublic" IS NULL OR r."isPublic" = "@isPublic");
END;
$body$
LANGUAGE 'plpgsql';
