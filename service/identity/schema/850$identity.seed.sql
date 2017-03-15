-- Insert identity hashes
DO
$do$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM identity.hash WHERE "identifier" = 'test') THEN
        INSERT INTO identity.hash("actorId", "type", "identifier", "algorithm", "params", "value", "isEnabled")
        VALUES ('1', 'password', 'test', 'pbkdf2', '{"salt":"2fd75123-1b6c-49a4-89e2-0d8932e20e2a","iterations":100000,"keylen":512,"digest":"sha512"}', 'b3055e040e06d0caf7c9570aed1cedafa75ea40798395d7266366f90318221ca562b684515efd30644a4daae0f366635e3061c93591ba8adb2da7087fd65b34489a782625e6c2bdd99be564edb6e2565d420c26d4dd01165b6d23364f34c153f7ad29f23fad6bf757bdc2b2e88918c713dfcd79b5d4b49cb6097773dae3583562a663bcbffa9207771fc5bc4a4599f680d28556cd0a610ad031ea08b14cd5ccc8bcbc15607e2d85011a4e15111e660a34b48c950b95973c4c17af0ccae02aba25bc803ec7f82ab4d9f15ea467a03f0cbb617c527980103e4cbfe8eb65dde2fc09d3611fe5244bc18ed3c5d1ae91997ae0c8e9592c295617a11fd6e59673c3b7e15821c8e66454313adcb81b4746a8298ca4cad0d400efa3eda37903d2ac346c19d562e5a461ce45d0e6bffb54f2af7e078fcba016e33451103a9f3cedc9d688a3fdd2e94838ebdf929ad3f57d3e3b2fbde40bcee3494ed254fd0c13feecc06d352fd1925af67bb6c6dfec994c4daaa11f7a43a5de985618fe3cd21c7524bc48a3dbbefb31c5a2fbf12e6f34629e5ae3fe6eda6662e1c5045f9cbf5f5f0abd896e9d7d8256422ebf5e4a6a9f63d15e3021eb5189516c4daffcbe8f273ffbcd433157565115a51dadd355a4fdc33c8693b99f053ba27f59346515d2104dae2e68111975acf5d6518cb7de3e18b2e03982bea4d7d5880398577d7c929ea0c538ff3', true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM identity.hash WHERE "identifier" = '0122523365225' AND type = 'password') THEN
        INSERT INTO identity.hash("actorId", "type", "identifier", "algorithm", "params", "value", "isEnabled")
        VALUES ('test-2', 'password', '0122523365225', 'pbkdf2', '{"salt":"2fd75123-1b6c-49a4-89e2-0d8932e20e2a","iterations":100000,"keylen":512,"digest":"sha512"}', 'b3055e040e06d0caf7c9570aed1cedafa75ea40798395d7266366f90318221ca562b684515efd30644a4daae0f366635e3061c93591ba8adb2da7087fd65b34489a782625e6c2bdd99be564edb6e2565d420c26d4dd01165b6d23364f34c153f7ad29f23fad6bf757bdc2b2e88918c713dfcd79b5d4b49cb6097773dae3583562a663bcbffa9207771fc5bc4a4599f680d28556cd0a610ad031ea08b14cd5ccc8bcbc15607e2d85011a4e15111e660a34b48c950b95973c4c17af0ccae02aba25bc803ec7f82ab4d9f15ea467a03f0cbb617c527980103e4cbfe8eb65dde2fc09d3611fe5244bc18ed3c5d1ae91997ae0c8e9592c295617a11fd6e59673c3b7e15821c8e66454313adcb81b4746a8298ca4cad0d400efa3eda37903d2ac346c19d562e5a461ce45d0e6bffb54f2af7e078fcba016e33451103a9f3cedc9d688a3fdd2e94838ebdf929ad3f57d3e3b2fbde40bcee3494ed254fd0c13feecc06d352fd1925af67bb6c6dfec994c4daaa11f7a43a5de985618fe3cd21c7524bc48a3dbbefb31c5a2fbf12e6f34629e5ae3fe6eda6662e1c5045f9cbf5f5f0abd896e9d7d8256422ebf5e4a6a9f63d15e3021eb5189516c4daffcbe8f273ffbcd433157565115a51dadd355a4fdc33c8693b99f053ba27f59346515d2104dae2e68111975acf5d6518cb7de3e18b2e03982bea4d7d5880398577d7c929ea0c538ff3', true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM identity.hash WHERE "identifier" = '0122523365225' AND type = 'ussd') THEN
        INSERT INTO identity.hash("actorId", "type", "identifier", "algorithm", "params", "value", "isEnabled")
        VALUES ('test-2', 'ussd', '0122523365225', '', '', '', true);
    END IF;

-- Insert actions
INSERT INTO
   identity."action" ("name", "description")
VALUES
  -- batch
  ('bulk.batch.add', 'Create new batch'),
  ('bulk.batch.edit', 'Edit batch'),
  ('bulk.batch.fetch', 'Fetch batches by criteria'),
  ('bulk.batch.get', 'Get batch details'),
  ('bulk.batch.reject', 'Reject batch'),
  ('bulk.batch.disable', 'Disable batch'),
  ('bulk.batch.pay', 'Pay batch'),
  ('bulk.batch.check', 'Chech batch'),
  ('bulk.batch.ready', 'Mark batch as ready'),
  ('bulk.batch.delete', 'Mark batch as deleted'),
  -- payment
  ('bulk.payment.check', 'Check payment'),
  ('bulk.payment.disable', 'Disable payment'),
  ('bulk.payment.edit', 'Edit payment'),
  ('bulk.payment.fetch', 'Fetch payments'),
  ('bulk.payment.add', 'Create payment'),
  -- bulk statuses
  ('bulk.paymentStatus.fetch', 'Fetch payment status'),
  ('bulk.batchStatus.fetch', 'Fetch batch status'),
  -- core
  ('core.translation.fetch', 'Translation fetch'),
  -- rule
  ('rule.rule.fetch', 'Rule fetch'),
  ('rule.item.fetch', 'Item fetch'),
  ('rule.rule.add', 'Rule add'),
  ('rule.rule.edit', 'Rule edit')
ON CONFLICT ("name") DO UPDATE SET "description" = EXCLUDED.description;

-- insert roles
INSERT INTO
   identity."role" ("name", "description")
VALUES
  ('common', 'Default role'),
  ('maker', 'Batch payment maker role'),
  ('checker', 'Batch payment checker role')
ON CONFLICT ("name") DO UPDATE SET "description" = EXCLUDED.description;

INSERT INTO
   identity."roleAction" ("roleId", "actionId")
SELECT
    (SELECT r."roleId" FROM identity."role" r WHERE r."name" = 'common'),
    a."actionId"
FROM
    identity."action" a
WHERE
    a.name IN (
        'core.translation.fetch',
        'rule.rule.fetch',
        'rule.item.fetch',
        'rule.rule.add',
        'rule.rule.edit'
    )
ON CONFLICT DO NOTHING;

INSERT INTO
   identity."roleAction" ("roleId", "actionId")
SELECT
    (SELECT r."roleId" FROM identity."role" r WHERE r."name" = 'maker'),
    a."actionId"
FROM
    identity."action" a
WHERE
    a.name IN (
        'bulk.batch.add',
        'bulk.batch.edit',
        'bulk.batch.fetch',
        'bulk.batch.get',
        'bulk.payment.add',
        'bulk.payment.edit',
        'bulk.batch.check',
        'bulk.batch.ready',
        'bulk.batch.delete',
        'bulk.payment.check',
        'bulk.payment.disable',
        'bulk.payment.edit',
        'bulk.payment.fetch',
        'bulk.batchStatus.fetch',
        'bulk.paymentStatus.fetch'
    )
ON CONFLICT DO NOTHING;


INSERT INTO
   identity."roleAction" ("roleId", "actionId")
SELECT
    (SELECT r."roleId" FROM identity."role" r WHERE r."name" = 'checker'),
    a."actionId"
FROM
    identity."action" a
WHERE
    a.name IN (
        'bulk.batch.reject',
        'bulk.batch.disable',
        'bulk.batch.pay',
        'bulk.batch.check',
        'bulk.payment.fetch',
        'bulk.batchStatus.fetch',
        'bulk.paymentStatus.fetch'
    )
ON CONFLICT DO NOTHING;

END
$do$
