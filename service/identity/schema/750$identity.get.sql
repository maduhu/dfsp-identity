CREATE OR REPLACE FUNCTION identity."get"(
  "@username" varchar(200),
  "@type" varchar(200)
) RETURNS TABLE (
  "hashParams" json,
  "roles" json,
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
    ),
    q2 AS (
      SELECT
        r.*
      FROM
        identity."actorRole" ar
      JOIN
        identity.role r
      on ar."roleId" = r."roleId"
      WHERE
        ar."actorId" = (
                          SELECT DISTINCT
                            q1."actorId"
                          FROM
                            q1
                       )
    )
  SELECT
    (SELECT json_agg(q1) FROM q1) AS "hashParams",
    (SELECT json_agg(q2) FROM q2) AS "roles",
    true "isSingleResult"
$body$
LANGUAGE SQL
