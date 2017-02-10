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

    -- PERMISIONS

    -- actions

    IF NOT EXISTS (SELECT 1 FROM identity.action WHERE "actionId" = 1) THEN
        INSERT INTO identity.action("actionId", "name", "description")
        VALUES (1, 'bulk.batch.add', 'Create new batch');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM identity.action WHERE "actionId" = 2) THEN
        INSERT INTO identity.action("actionId", "name", "description")
        VALUES (2, 'bulk.batch.edit', 'Edit batch');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM identity.action WHERE "actionId" = 3) THEN
        INSERT INTO identity.action("actionId", "name", "description")
        VALUES (3, 'bulk.batch.fetch', 'Fetch batches by criteria');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM identity.action WHERE "actionId" = 4) THEN
        INSERT INTO identity.action("actionId", "name", "description")
        VALUES (4, 'bulk.batch.get', 'Get batch details');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM identity.action WHERE "actionId" = 5) THEN
        INSERT INTO identity.action("actionId", "name", "description")
        VALUES (5, 'bulk.payment.add', 'Create payment');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM identity.action WHERE "actionId" = 6) THEN
        INSERT INTO identity.action("actionId", "name", "description")
        VALUES (6, 'bulk.payment.edit', 'Edit payment');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM identity.action WHERE "actionId" = 7) THEN
        INSERT INTO identity.action("actionId", "name", "description")
        VALUES (7, 'bulk.batch.reject', 'Reject batch');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM identity.action WHERE "actionId" = 8) THEN
        INSERT INTO identity.action("actionId", "name", "description")
        VALUES (8, 'bulk.batch.return', 'Return batch');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM identity.action WHERE "actionId" = 9) THEN
        INSERT INTO identity.action("actionId", "name", "description")
        VALUES (9, 'bulk.batch.pay', 'Pay batch');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM identity.action WHERE "actionId" = 10) THEN
        INSERT INTO identity.action("actionId", "name", "description")
        VALUES (10, 'bulk.batch.check', 'Chech batch');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM identity.action WHERE "actionId" = 11) THEN
        INSERT INTO identity.action("actionId", "name", "description")
        VALUES (11, 'bulk.batch.ready', 'Mark batch as ready');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM identity.action WHERE "actionId" = 12) THEN
        INSERT INTO identity.action("actionId", "name", "description")
        VALUES (12, 'bulk.payment.check', 'Check payment');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM identity.action WHERE "actionId" = 13) THEN
        INSERT INTO identity.action("actionId", "name", "description")
        VALUES (13, 'bulk.payment.disable', 'Disable payment');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM identity.action WHERE "actionId" = 14) THEN
        INSERT INTO identity.action("actionId", "name", "description")
        VALUES (14, 'bulk.payment.edit', 'Edit payment');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM identity.action WHERE "actionId" = 15) THEN
        INSERT INTO identity.action("actionId", "name", "description")
        VALUES (15, 'core.translation.fetch', 'Translation fetch');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM identity.action WHERE "actionId" = 16) THEN
        INSERT INTO identity.action("actionId", "name", "description")
        VALUES (16, 'rule.rule.fetch', 'Translation fetch');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM identity.action WHERE "actionId" = 17) THEN
        INSERT INTO identity.action("actionId", "name", "description")
        VALUES (17, 'rule.item.fetch', 'Translation fetch');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM identity.action WHERE "actionId" = 18) THEN
        INSERT INTO identity.action("actionId", "name", "description")
        VALUES (18, 'rule.rule.add', 'Translation fetch');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM identity.action WHERE "actionId" = 19) THEN
        INSERT INTO identity.action("actionId", "name", "description")
        VALUES (19, 'rule.rule.edit', 'Translation fetch');
    END IF;

    -- roles

    IF NOT EXISTS (SELECT 1 FROM identity.role WHERE "roleId" = 1) THEN
        INSERT INTO identity.role("roleId", "name", "description")
        VALUES (1, 'common', 'Default role');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM identity.role WHERE "roleId" = 2) THEN
        INSERT INTO identity.role("roleId", "name", "description")
        VALUES (2, 'maker', 'Batch payment maker role');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM identity.role WHERE "roleId" = 3) THEN
        INSERT INTO identity.role("roleId", "name", "description")
        VALUES (3, 'cheker', 'Batch payment cheker role');
    END IF;

    -- role-action mapping

    IF NOT EXISTS (SELECT 1 FROM identity."roleAction" WHERE "roleId" = 2 AND "actionId" = 1) THEN
        INSERT INTO identity."roleAction"("roleId", "actionId")
        VALUES (2, 1);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM identity."roleAction" WHERE "roleId" = 2 AND "actionId" = 2) THEN
        INSERT INTO identity."roleAction"("roleId", "actionId")
        VALUES (2, 2);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM identity."roleAction" WHERE "roleId" = 2 AND "actionId" = 3) THEN
        INSERT INTO identity."roleAction"("roleId", "actionId")
        VALUES (2, 3);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM identity."roleAction" WHERE "roleId" = 2 AND "actionId" = 4) THEN
        INSERT INTO identity."roleAction"("roleId", "actionId")
        VALUES (2, 4);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM identity."roleAction" WHERE "roleId" = 2 AND "actionId" = 5) THEN
        INSERT INTO identity."roleAction"("roleId", "actionId")
        VALUES (2, 5);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM identity."roleAction" WHERE "roleId" = 2 AND "actionId" = 6) THEN
        INSERT INTO identity."roleAction"("roleId", "actionId")
        VALUES (2, 6);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM identity."roleAction" WHERE "roleId" = 3 AND "actionId" = 7) THEN
        INSERT INTO identity."roleAction"("roleId", "actionId")
        VALUES (3, 7);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM identity."roleAction" WHERE "roleId" = 3 AND "actionId" = 8) THEN
        INSERT INTO identity."roleAction"("roleId", "actionId")
        VALUES (3, 8);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM identity."roleAction" WHERE "roleId" = 3 AND "actionId" = 9) THEN
        INSERT INTO identity."roleAction"("roleId", "actionId")
        VALUES (3, 9);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM identity."roleAction" WHERE "roleId" = 2 AND "actionId" = 10) THEN
        INSERT INTO identity."roleAction"("roleId", "actionId")
        VALUES (2, 10);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM identity."roleAction" WHERE "roleId" = 3 AND "actionId" = 10) THEN
        INSERT INTO identity."roleAction"("roleId", "actionId")
        VALUES (3, 10);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM identity."roleAction" WHERE "roleId" = 2 AND "actionId" = 11) THEN
        INSERT INTO identity."roleAction"("roleId", "actionId")
        VALUES (2, 11);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM identity."roleAction" WHERE "roleId" = 2 AND "actionId" = 12) THEN
        INSERT INTO identity."roleAction"("roleId", "actionId")
        VALUES (2, 12);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM identity."roleAction" WHERE "roleId" = 2 AND "actionId" = 13) THEN
        INSERT INTO identity."roleAction"("roleId", "actionId")
        VALUES (2, 13);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM identity."roleAction" WHERE "roleId" = 2 AND "actionId" = 14) THEN
        INSERT INTO identity."roleAction"("roleId", "actionId")
        VALUES (2, 14);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM identity."roleAction" WHERE "roleId" = 1 AND "actionId" = 15) THEN
        INSERT INTO identity."roleAction"("roleId", "actionId")
        VALUES (1, 15);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM identity."roleAction" WHERE "roleId" = 1 AND "actionId" = 16) THEN
        INSERT INTO identity."roleAction"("roleId", "actionId")
        VALUES (1, 16);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM identity."roleAction" WHERE "roleId" = 1 AND "actionId" = 17) THEN
        INSERT INTO identity."roleAction"("roleId", "actionId")
        VALUES (1, 17);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM identity."roleAction" WHERE "roleId" = 1 AND "actionId" = 18) THEN
        INSERT INTO identity."roleAction"("roleId", "actionId")
        VALUES (1, 18);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM identity."roleAction" WHERE "roleId" = 1 AND "actionId" = 19) THEN
        INSERT INTO identity."roleAction"("roleId", "actionId")
        VALUES (1, 19);
    END IF;
END
$do$
