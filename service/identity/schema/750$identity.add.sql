CREATE OR REPLACE FUNCTION identity."add"(
  "@hash.actorId" varchar(25),
  "@hash.type" varchar(50),
  "@hash.identifier" varchar(200),
  "@hash.algorithm" varchar(50),
  "@hash.params" text,
  "@hash.value" text,
  "@roles" varchar(10)[] -- array of role names
) RETURNS TABLE (
  "actor" json,
  "isSingleResult" boolean
)
AS
$body$
  INSERT INTO
    identity.hash("actorId", "type", "identifier", "algorithm", "params", "value", "isEnabled")
  VALUES
    ("@hash.actorId", "@hash.type", "@hash.identifier", "@hash.algorithm", "@hash.params", "@hash.value", true);

  INSERT INTO identity."actorRole"(
    "actorId",
    "roleId"
  )
  SELECT
    "@hash.actorId",
    ir."roleId"
  FROM
    identity."role" ir WHERE ir."name" IN (SELECT unnest("@roles"));

  WITH
    q1 AS (
      SELECT
        "@hash.actorId" "actorId"
    )
  SELECT
    (SELECT json_agg(q1) FROM q1) AS "actor",
    true "isSingleResult"
$body$
LANGUAGE SQL
