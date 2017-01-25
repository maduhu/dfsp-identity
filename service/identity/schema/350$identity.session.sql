CREATE TABLE identity."session"
(
  "sessionId" UUID,
  "actorId" varchar(25) NOT NULL,
  "cookie" varchar(50) NOT NULL,
  "language" varchar(3),
  "module" varchar(50),
  "remoteIP" varchar(50),
  "userAgent" varchar(500),
  "expire" timestamp NOT NULL,
  "dateCreated" timestamp NOT NULL,
  CONSTRAINT pkIdentitySession PRIMARY KEY ("sessionId")
)
