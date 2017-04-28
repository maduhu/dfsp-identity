CREATE OR REPLACE FUNCTION identity."get"(
  "@username" varchar(200),
  "@actorId" varchar(25),
  "@type" varchar(200)
) RETURNS TABLE (
  "hashParams" json,
  "roles" json,
  "isSingleResult" boolean
)
AS
$body$
DECLARE
        "@hashParams" json;
        "@roles" json;
BEGIN
  IF ("@type" IS NULL) THEN
    RAISE EXCEPTION 'identity.typeMissing';
  END IF;

  WITH
    q1 AS (
    SELECT
      h.params,
      h.algorithm,
      h."actorId",
      h.type
    FROM
      identity.hash h
    WHERE
      h.type = "@type" AND
      ("@actorId" IS NULL OR  h."actorId" = "@actorId") AND
      ("@username" IS NULL OR  h.identifier = "@username") AND
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
      (SELECT json_agg(q2) FROM q2) AS "roles"
    INTO
      "@hashParams",
      "@roles";

RETURN QUERY
  SELECT
    "@hashParams" AS "hashParams",
    "@roles" AS "roles",
    true "isSingleResult";
END;
$body$
LANGUAGE 'plpgsql';
