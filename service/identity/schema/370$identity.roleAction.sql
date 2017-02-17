CREATE TABLE identity."roleAction"
(
  "roleId" INTEGER NOT NULL,
  "actionId" INTEGER NOT NULL,
  CONSTRAINT "fkIdentityRoleAction_roleId" FOREIGN KEY ("roleId") REFERENCES identity."role"("roleId"),
  CONSTRAINT "fkIdentityRoleAction_actionId" FOREIGN KEY ("actionId") REFERENCES identity."action"("actionId"),
  CONSTRAINT "ukIdentityRoleAction_actionId_roleId" UNIQUE ("actionId", "roleId")
)
