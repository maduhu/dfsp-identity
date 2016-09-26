CREATE OR REPLACE FUNCTION identity."get"(
  "@username" varchar(200),
  "@type" varchar(200)
) RETURNS TABLE (
  "hashParams" json,
  "isSingleResult" boolean
)
AS
$body$
  WITH
    q1 AS (
      SELECT
        h.params,
        h.algorithm,
        h."actorId",
        h.type
      FROM
        identity.hash h
      JOIN
        identity.hash u ON u.identifier="@username" AND u.type IN ('password', 'registerPassword')
      WHERE
        h."actorId" = u."actorId" AND
        ("@type" IS NULL OR  h.type = "@type") AND
        h."isEnabled" = true
    )
  SELECT
    (SELECT json_agg(q1) FROM q1) AS "hashParams",
    true "isSingleResult"
$body$
LANGUAGE SQL
