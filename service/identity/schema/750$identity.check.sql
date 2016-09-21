CREATE OR REPLACE FUNCTION identity."check"(
  "@username" varchar(200),
  "@password" varchar(200),
  "@newPassword" varchar(200),
  "@sessionId" varchar(200)
) RETURNS TABLE (
  "identity.check" json,
  "permission.get" json,
  "person" json,
  "language" json,
  "isSingleResult" boolean
)
AS
$body$
  WITH
    q1 AS (
      SELECT
        h."actorId"
      FROM
        identity.hash h
      WHERE
        h.identifier = "@username" AND h.type = 'password' AND h.value = "@password"
    )
  SELECT
    (SELECT json_agg(q1) FROM q1) AS "identity.check",
    '["*"]'::json AS "permission.get",
    '{}'::json AS person,
    '{"iso2Code":"en"}'::json AS language,
    true "isSingleResult"
$body$
LANGUAGE SQL