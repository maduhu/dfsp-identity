CREATE OR REPLACE FUNCTION identity."role.fetch"(

) RETURNS TABLE (
  "roleId" INTEGER,
  "name" VARCHAR(10),
  "description" VARCHAR(50)
)
AS
$body$
BEGIN
  RETURN QUERY
  SELECT
    r."roleId", r."name", r."description"
  FROM
     identity."role" r;
END;
$body$
LANGUAGE 'plpgsql';
