-- Insert identity hashes
DO
$do$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM identity.hash WHERE "identifier" = 'test') THEN
        INSERT INTO identity.hash("actorId", "type", "identifier", "algorithm", "params", "value", "isEnabled")
        VALUES ('1', 'password', 'test', 'pbkdf2', '{"salt":"2fd75123-1b6c-49a4-89e2-0d8932e20e2a","iterations":10000,"keylen":512,"digest":"sha512"}', '2dfc04d8993db637e730a7f80328573322dc697c9073b577166000924224a18b0085830c301f02b6c14c84b1bba0bf78860b66c402db2e9c41ef3d11637733bfcf2a640e21552089066e5d0beccbc3c4c0afd3dc72a807fbb9f1273341cca0a277f437341662e45b801efae0171f2cba6fb2d228e9fc27ee34175dd0efdf2d89e942c85e099d4aa318e214063cf0ceac1e92d095c8ec4271335ac6b01c549fa185a237f576880733c1a5bd975bba93897978b19a885adabc88a9b7baf57a6fcde6cb8ccdd2f09ba78fc884a6f8fc2a1a8732da932e8011757b67b4a627a1a7b08fca77aba858bd2b983d742b13328e4f4541395ec41276628bdb6c34d02e915c6f3781b14acb4491a34049f28169adeed91c1202f856ee6b9fbbd66b0cc866a5caff7657c8cb95cd88240dad94695364167f1d6cab71c8eb56481cc0355acaf1cf50d12ce1db9496b16b66f144ca14b440a1fbacebddace676d888f1a24cccd783afa22ca02acf410c92df8533a54f90cd07fcd4590d45982b878a41072f29ce8040557dab0d14f6480b90c278debb91e808e3096ba3d388e8b297090284f647cd9563dc068b785af892fa61a9faf0ca0f57f8ee948093a5ca870fd3cc66226d36eee7c8fdad29167493519434166d68a33aedab909558210d310c3f516e211890821460f92391e7c601abf0f4ceee21d47074a099d6a45aeb5e688d641aec20', true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM identity.hash WHERE "identifier" = '0122523365225' AND type = 'password') THEN
        INSERT INTO identity.hash("actorId", "type", "identifier", "algorithm", "params", "value", "isEnabled")
        VALUES ('test-2', 'password', '0122523365225', 'pbkdf2', '{"salt":"2fd75123-1b6c-49a4-89e2-0d8932e20e2a","iterations":10000,"keylen":512,"digest":"sha512"}', '2dfc04d8993db637e730a7f80328573322dc697c9073b577166000924224a18b0085830c301f02b6c14c84b1bba0bf78860b66c402db2e9c41ef3d11637733bfcf2a640e21552089066e5d0beccbc3c4c0afd3dc72a807fbb9f1273341cca0a277f437341662e45b801efae0171f2cba6fb2d228e9fc27ee34175dd0efdf2d89e942c85e099d4aa318e214063cf0ceac1e92d095c8ec4271335ac6b01c549fa185a237f576880733c1a5bd975bba93897978b19a885adabc88a9b7baf57a6fcde6cb8ccdd2f09ba78fc884a6f8fc2a1a8732da932e8011757b67b4a627a1a7b08fca77aba858bd2b983d742b13328e4f4541395ec41276628bdb6c34d02e915c6f3781b14acb4491a34049f28169adeed91c1202f856ee6b9fbbd66b0cc866a5caff7657c8cb95cd88240dad94695364167f1d6cab71c8eb56481cc0355acaf1cf50d12ce1db9496b16b66f144ca14b440a1fbacebddace676d888f1a24cccd783afa22ca02acf410c92df8533a54f90cd07fcd4590d45982b878a41072f29ce8040557dab0d14f6480b90c278debb91e808e3096ba3d388e8b297090284f647cd9563dc068b785af892fa61a9faf0ca0f57f8ee948093a5ca870fd3cc66226d36eee7c8fdad29167493519434166d68a33aedab909558210d310c3f516e211890821460f92391e7c601abf0f4ceee21d47074a099d6a45aeb5e688d641aec20', true);
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
  ('bulk.batch.process', 'Process batch'),
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
  ('rule.rule.edit', 'Rule edit'),
  -- ledger
  ('ledger.account.fetch', 'Fetch accounts'),
  -- notifications
  ('notification.channel.fetch', 'Fetch channels'),
  ('notification.channel.get', 'Get channel'),
  ('notification.notification.add', 'Add notification'),
  ('notification.notification.edit', 'Edit notification'),
  ('notification.notification.fetch', 'Fetch notifications'),
  ('notification.operation.fetch', 'Fetch operations'),
  ('notification.operation.get', 'Get operation'),
  ('notification.status.fetch', 'Fetch statuses'),
  ('notification.status.get', 'Get status'),
  ('notification.target.fetch', 'Fetch targets'),
  ('notification.target.get', 'Get target'),
  ('notification.template.add', 'Add template'),
  ('notification.template.edit', 'Edit template'),
  ('notification.template.fetch', 'Fetch templates'),
  ('notification.template.get', 'Get template')
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
        'rule.rule.edit',
        'notification.channel.fetch',
        'notification.channel.get',
        'notification.notification.add',
        'notification.notification.edit',
        'notification.notification.fetch',
        'notification.operation.fetch',
        'notification.operation.get',
        'notification.status.fetch',
        'notification.status.get',
        'notification.target.fetch',
        'notification.target.get',
        'notification.template.add',
        'notification.template.edit',
        'notification.template.fetch',
        'notification.template.get'
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
        'bulk.batch.fetch',
        'bulk.batch.get',
        'bulk.batch.process',
        'bulk.payment.fetch',
        'bulk.payment.check',
        'bulk.payment.disable',
        'bulk.batchStatus.fetch',
        'bulk.paymentStatus.fetch',
        'ledger.account.fetch'
    )
ON CONFLICT DO NOTHING;

END
$do$
