CREATE OR REPLACE FUNCTION identity."check"(
  "@actorId" VARCHAR(25),
  "@username" VARCHAR(200),
  "@password" VARCHAR(200),
  "@newPassword" VARCHAR(200),
  "@sessionId" UUID
) RETURNS TABLE (
  "identity.check" JSON,
  "permission.get" JSON,
  "person" JSON,
  "language" JSON,
  "localisation" JSON,
  "roles" JSON,
  "emails" JSON,
  "screenHeader" TEXT,
  "isSingleResult" BOOLEAN
)
AS
$body$
  DECLARE "@actorIdOut" VARCHAR(25);
  DECLARE "@sessionIdOut" UUID;
  BEGIN
    IF ("@username" IS NOT NULL) THEN
      IF ("@password" IS NULL) THEN
        RAISE EXCEPTION 'policy.param.password';
      ELSE
        BEGIN
            SELECT
              h."actorId"
            INTO STRICT
              "@actorIdOut"
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
        SELECT
          s."sessionId"
        INTO
          "@sessionIdOut"
        FROM
          identity."session" s
        WHERE
          s."actorId" = "@actorIdOut";
        IF ("@sessionIdOut" IS NULL) THEN
            SELECT md5(random()::text || clock_timestamp()::text)::uuid INTO "@sessionIdOut";
            INSERT INTO identity."session" (
              "sessionId",
              "actorId",
              "cookie",
              "language",
              "module",
              "remoteIP",
              "userAgent",
              "expire",
              "dateCreated"
            ) VALUES (
              "@sessionIdOut",
              "@actorIdOut",
              '???cookie???',
              'en',
              '',
              '',
              '',
              NOW() + interval '10 minutes',
              NOW()
            );
        END IF;
      END IF;
    ELSEIF ("@sessionId" IS NOT NULL AND "@actorId" IS NOT NULL) THEN
      IF NOT EXISTS(SELECT 1 FROM identity."session" WHERE "sessionId" = "@sessionId" AND "actorId" = "@actorId") THEN
        RAISE EXCEPTION 'identity.invalidSession';
      ELSE
        "@sessionIdOut" := "@sessionId";
        "@actorIdOut" := "@actorId";
      END IF;
    ELSE
      RAISE EXCEPTION 'identity.invalidArguments333333333333';
      --RAISE EXCEPTION 'identity.invalidArguments - sessionId: (%), actorId: (%)!', "@sessionId", "@actorId";
    END IF;

    RETURN QUERY WITH
      q1 AS (
        SELECT
          "@actorIdOut" AS "actorId",
          "@sessionIdOut" AS "sessionId"
      ),
      q2 AS (
        SELECT
          "@actorIdOut" AS "actorId",
          'L1P' AS "firstName",
          'User' AS "lastName"
      )
    SELECT
      (SELECT row_to_json(q1) FROM q1) AS "identity.check",
      '[{"actionId": "%", "objectId": "%", "description": "Full Access"}]'::json AS "permission.get",
      (SELECT row_to_json(q2) FROM q2) AS "person",
      '{"iso2Code":"en"}'::json AS "language",
      '{"dateFormat": null,"numberFormat": null}'::json AS "localisation",
      '[]'::json AS "roles",
      '[]'::json AS "emails",
      ''::text AS "screenHeader",
      true AS "isSingleResult";
  END
$body$
LANGUAGE PLPGSQL
