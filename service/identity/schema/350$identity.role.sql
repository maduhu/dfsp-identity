CREATE TABLE identity."role"
(
  "roleId" serial NOT NULL,
  "name" varchar(10) NOT NULL,
  "description" varchar(50) NOT NULL,
  CONSTRAINT pkIdentityRole PRIMARY KEY ("roleId"),
  CONSTRAINT ukIdentityRoleName UNIQUE (name)
)
