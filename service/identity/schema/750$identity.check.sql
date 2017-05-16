CREATE OR REPLACE FUNCTION identity."check"(
  "@actorId" VARCHAR(25),
  "@username" VARCHAR(200),
  "@password" VARCHAR(200),
  "@newPassword" VARCHAR(200),
  "@sessionId" UUID
) RETURNS TABLE (
  "identity.check" JSON,
  "permission.get" JSON,
  "language" JSON,
  "localisation" JSON,
  "roles" JSON,
  "screenHeader" TEXT,
  "isSingleResult" BOOLEAN
)
AS
$body$
  DECLARE "@usernameTokens" text[];
  BEGIN
    IF ("@username" IS NOT NULL) THEN
      "@usernameTokens" := string_to_array("@username", '@');
      "@username" := "@usernameTokens"[1];
      IF ("@password" IS NULL) THEN
        IF EXISTS (SELECT * FROM identity."hash" WHERE "identifier" = "@username") THEN
          RAISE EXCEPTION 'policy.param.password';
        ELSE
          RAISE EXCEPTION 'identity.invalidCredentials';
        END IF;
      ELSE
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
        SELECT
          s."sessionId"
        INTO
          "@sessionId"
        FROM
          identity."session" s
        WHERE
          s."actorId" = "@actorId";
        IF ("@sessionId" IS NULL) THEN
            SELECT md5(random()::text || clock_timestamp()::text)::uuid INTO "@sessionId";
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
              "@sessionId",
              "@actorId",
              '???cookie???',
              'en',
              '',
              '',
              '',
              NOW() + interval '10 minutes',
              NOW()
            );
        END IF;
        -- TODO: remove dynamic deletion and insertion of roles once they get configurable
        -- delete roles
        DELETE FROM
          identity."actorRole"
        WHERE
          "actorId" = "@actorId" AND "roleId" IN (SELECT ir."roleId" FROM identity."role" ir WHERE ir."name" IN ('maker', 'checker', 'common'));
        -- insert roles again for the user
        INSERT INTO
          identity."actorRole" ("actorId", "roleId")
        SELECT
          "@actorId", r."roleId"
        FROM
          identity."role" AS r
        WHERE
          r."name" = "@usernameTokens"[2] OR r."name" = 'common';
      END IF;
    ELSEIF ("@sessionId" IS NOT NULL AND "@actorId" IS NOT NULL) THEN
      IF NOT EXISTS(SELECT 1 FROM identity."session" WHERE "sessionId" = "@sessionId" AND "actorId" = "@actorId") THEN
        RAISE EXCEPTION 'identity.invalidSession';
      END IF;
    ELSE
      RAISE EXCEPTION 'identity.invalidArguments';
      --RAISE EXCEPTION 'identity.invalidArguments - sessionId: (%), actorId: (%)!', "@sessionId", "@actorId";
    END IF;

    RETURN QUERY
      SELECT
        json_build_object('actorId', s."actorId", 'sessionId', s."sessionId") AS "identity.check",
        (
          SELECT array_to_json(
            ARRAY(
              SELECT json_build_object('actionId', a.name, 'objectId', '%', 'description', a.description)
              FROM identity."action" AS a
              WHERE a."actionId" IN (
                  SELECT ra."actionId"
                  FROM identity."roleAction" AS ra
                  WHERE ra."roleId" = ANY(array_agg(r."roleId"))
              )
              GROUP BY a."name", a."description"
            )
          )
        )  AS "permission.get",
        '{"iso2Code":"en"}'::json AS "language",
        '{"dateFormat": "YYYY-MM-DD","numberFormat": null}'::json AS "localisation",
        array_to_json(array_agg(r."name")) AS "roles",
        ''::text AS "screenHeader",
        true AS "isSingleResult"
      FROM
        identity."session" s
      LEFT JOIN
        identity."actorRole" ar ON s."actorId" = ar."actorId"
      LEFT JOIN
        identity."role" r ON ar."roleId" = r."roleId"
      WHERE
        s."sessionId" = "@sessionId" AND s."actorId" = "@actorId"
      GROUP BY s."sessionId", s."actorId";
  END
$body$
LANGUAGE PLPGSQL
