CREATE TABLE identity."hash"
(
  "hashId" serial NOT NULL,
  "actorId" varchar(25) NOT NULL,
  "type" varchar(50) NOT NULL,
  "identifier" varchar(200) NOT NULL,
  "algorithm" varchar(50) NOT NULL,
  "params" text NOT NULL,
  "value" text NOT NULL,
  "failedAttempts" int,
  "lastAttempt" timestamp,
  "lastChange" timestamp,
  "expireDate" timestamp,
  "isEnabled" boolean NOT NULL,
  CONSTRAINT pkIdentityHash PRIMARY KEY ("hashId"),
  CONSTRAINT ukIdentityHashType_Identifier UNIQUE (type, identifier)
)
