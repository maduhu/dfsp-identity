CREATE TABLE identity."action"
(
  "actionId" SERIAL NOT NULL,
  "name" VARCHAR(100) NOT NULL,
  "description" VARCHAR(255) NOT NULL,
  CONSTRAINT pkIdentityActionId PRIMARY KEY ("actionId"),
  CONSTRAINT ukIdentityActionName UNIQUE (name)
)
