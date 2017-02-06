CREATE TABLE identity."actorRole"
(
  "actorId" varchar(25) NOT NULL,
  "roleId" INT NOT NULL,
  CONSTRAINT ukIdentityActorRole__ActorId_RoleId UNIQUE ("actorId", "roleId")
)
