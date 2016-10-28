CREATE OR REPLACE FUNCTION identity."check"(
  "@username" VARCHAR(200),
  "@password" VARCHAR(200),
  "@newPassword" VARCHAR(200),
  "@sessionId" VARCHAR(200)
) RETURNS TABLE (
  "identity.check" JSON,
  "permission.get" JSON,
  "person" JSON,
  "language" JSON,
  "isSingleResult" BOOLEAN
)
AS
$body$
  DECLARE
    "@actorId" VARCHAR(25);
  BEGIN
    BEGIN
      SELECT
        h."actorId"
      INTO STRICT
        "@actorId"
      FROM
        identity.hash h
      WHERE
        h.identifier = "@username" AND h.type = 'password' AND h.value = "@password" AND h."isEnabled" = true;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE EXCEPTION 'identity.invalidCredentials';
      WHEN TOO_MANY_ROWS THEN
        RAISE EXCEPTION 'identity.multipleResults';
    END;
    RETURN QUERY WITH
      q1 AS (
        SELECT
          "@actorId" AS "actorId",
          '123456789' AS "sessionId"
      )
    SELECT
      (SELECT row_to_json(q1) FROM q1) AS "identity.check",
      '["*"]'::json AS "permission.get",
      '{}'::json AS person,
      '{"iso2Code":"en"}'::json AS language,
      true "isSingleResult";
  END
$body$
LANGUAGE PLPGSQL