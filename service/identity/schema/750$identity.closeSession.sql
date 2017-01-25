CREATE OR REPLACE FUNCTION identity."closeSession"(
  "@actorId" VARCHAR(25),
  "@sessionId" UUID
) RETURNS TABLE (
  "data" JSON,
  "isSingleResult" BOOLEAN
)
AS
$body$
  BEGIN
    DELETE FROM
      identity."session"
    WHERE
      "sessionId" = "@sessionId" AND "actorId" = "@actorId";
    RETURN QUERY
      SELECT
        '[]'::json AS "data",
        true AS "isSingleResult";
  END
$body$
LANGUAGE plpgsql
