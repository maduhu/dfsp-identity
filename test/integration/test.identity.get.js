var test = require('ut-run/test')
var config = require('./../lib/appConfig')

const TIMESTAMP = (new Date()).getTime()
const ACCOUNT_ACTOR_ID_1 = 'ActorId_1_' + TIMESTAMP
const ACCOUNT_ACTOR_ID_2 = 'ActorId_2_' + TIMESTAMP
const ACCOUNT_ACTOR_ID_3 = 'ActorId_3_' + TIMESTAMP
const IDENTIFIER_1 = 'Identifier_1_' + TIMESTAMP
const IDENTIFIER_2 = 'Identifier_2_' + TIMESTAMP
const IDENTIFIER_3 = 'Identifier_3_' + TIMESTAMP
const PASSWORD_1 = 'pass_1_' + TIMESTAMP
const PASSWORD_2 = 'pass_2_' + TIMESTAMP
const PASSWORD_3 = 'pass_3_' + TIMESTAMP
const KEYLEN = 512
const DIGEST = 'sha512'
const ALGORITHM = 'pbkdf2'
const PASSWORD_TYPE = 'password'
const PUBLIC_ROLES = ['customer', 'merchant', 'agent']
const NOT_PUBLIC_ROLES = ['common', 'maker', 'checker']

test({
  type: 'integration',
  name: 'DFSP identity get',
  server: config.server,
  serverConfig: config.serverConfig,
  client: config.client,
  clientConfig: config.clientConfig,
  steps: function (test, bus, run) {
    return run(test, bus, [
      {
        name: 'Add hash #1',
        method: 'identity.add',
        params: (context) => {
          return {
            hash: {
              actorId: ACCOUNT_ACTOR_ID_1,
              type: 'password',
              identifier: IDENTIFIER_1,
              password: PASSWORD_1
            },
            roles: PUBLIC_ROLES
          }
        },
        result: (result, assert) => {
          assert.deepEquals(
            result,
            {
              actor: [{ 'actorId': ACCOUNT_ACTOR_ID_1 }]
            },
            'hash #1 successfully added - identity get'
          )
        }
      },
      {
        name: 'Identity get',
        method: 'identity.get',
        params: (context) => {
          return {
            username: IDENTIFIER_1,
            type: 'password'
          }
        },
        result: (result, assert) => {
          let hashParams = result.hashParams
          let roles = result.roles

          roles.forEach((role) => {
            assert.true(typeof role.roleId === 'number', 'Check roleId type')
            assert.true(typeof role.name === 'string', 'Check role name type')
            assert.true(typeof role.description === 'string', 'Check role description type')
            assert.true(typeof role.isPublic === 'boolean', 'Check role isPublic type')
            assert.equal(role.isPublic, true, 'Check role isPublic value for ' + role.name)
            assert.true(PUBLIC_ROLES.indexOf(role.name) > -1, 'Check that returned roles are public')
          })

          assert.equal(hashParams[0].actorId, ACCOUNT_ACTOR_ID_1, 'Check returned actorId')
          assert.equal(hashParams[0].algorithm, ALGORITHM, 'Check returned algorithm')
          assert.equal(hashParams[0].type, PASSWORD_TYPE, 'Check returned type')

          let paramsObject = JSON.parse(hashParams[0].params)
          assert.true(typeof paramsObject.salt === 'string', 'Check salt type - string')
          assert.true(typeof paramsObject.iterations === 'number', 'Check iterations type - number')

          assert.true(typeof paramsObject.keylen === 'number', 'Check keylen type - string')
          assert.equal(paramsObject.keylen, KEYLEN, 'Check keylen value')

          assert.true(typeof paramsObject.digest === 'string', 'Check digest type - string')
          assert.equal(paramsObject.digest, DIGEST, 'Check digest value')
        }
      },
      {
        name: 'Add hash #2',
        method: 'identity.add',
        params: (context) => {
          return {
            hash: {
              actorId: ACCOUNT_ACTOR_ID_2,
              type: 'password',
              identifier: IDENTIFIER_2,
              password: PASSWORD_2
            },
            roles: NOT_PUBLIC_ROLES
          }
        },
        result: (result, assert) => {
          assert.deepEquals(
            result,
            {
              actor: [{ 'actorId': ACCOUNT_ACTOR_ID_2 }]
            },
            'hash #2 successfully added - identity get'
          )
        }
      },
      {
        name: 'Identity get',
        method: 'identity.get',
        params: (context) => {
          return {
            username: IDENTIFIER_2,
            type: 'password'
          }
        },
        result: (result, assert) => {
          let hashParams = result.hashParams
          let roles = result.roles

          roles.forEach((role) => {
            assert.true(typeof role.roleId === 'number', 'Check roleId type')
            assert.true(typeof role.name === 'string', 'Check role name type')
            assert.true(typeof role.description === 'string', 'Check role description type')
            assert.true(typeof role.isPublic === 'boolean', 'Check role isPublic type')
            assert.equal(role.isPublic, false, 'Check role isPublic value for ' + role.name)
            assert.true(NOT_PUBLIC_ROLES.indexOf(role.name) > -1, 'Check that returned roles are not public')
          })

          assert.equal(hashParams[0].actorId, ACCOUNT_ACTOR_ID_2, 'Check returned actorId')
          assert.equal(hashParams[0].algorithm, ALGORITHM, 'Check returned algorithm')
          assert.equal(hashParams[0].type, PASSWORD_TYPE, 'Check returned type')

          let paramsObject = JSON.parse(hashParams[0].params)
          assert.true(typeof paramsObject.salt === 'string', 'Check salt type - string')
          assert.true(typeof paramsObject.iterations === 'number', 'Check iterations type - number')

          assert.true(typeof paramsObject.keylen === 'number', 'Check keylen type - string')
          assert.equal(paramsObject.keylen, KEYLEN, 'Check keylen value')

          assert.true(typeof paramsObject.digest === 'string', 'Check digest type - string')
          assert.equal(paramsObject.digest, DIGEST, 'Check digest value')
        }
      },
      {
        name: 'Add hash #3 - without roles',
        method: 'identity.add',
        params: (context) => {
          return {
            hash: {
              actorId: ACCOUNT_ACTOR_ID_3,
              type: 'password',
              identifier: IDENTIFIER_3,
              password: PASSWORD_3
            }
          }
        },
        result: (result, assert) => {
          assert.deepEquals(
            result,
            {
              actor: [{ 'actorId': ACCOUNT_ACTOR_ID_3 }]
            },
            'hash #3 successfully added - identity get'
          )
        }
      },
      {
        name: 'Identity get',
        method: 'identity.get',
        params: (context) => {
          return {
            username: IDENTIFIER_3,
            type: 'password'
          }
        },
        result: (result, assert) => {
          let hashParams = result.hashParams

          assert.equal(result.roles, null, 'Check that there are not assigned roles')
          assert.equal(hashParams[0].actorId, ACCOUNT_ACTOR_ID_3, 'Check returned actorId')
          assert.equal(hashParams[0].algorithm, ALGORITHM, 'Check returned algorithm')
          assert.equal(hashParams[0].type, PASSWORD_TYPE, 'Check returned type')

          let paramsObject = JSON.parse(hashParams[0].params)
          assert.true(typeof paramsObject.salt === 'string', 'Check salt type - string')
          assert.true(typeof paramsObject.iterations === 'number', 'Check iterations type - number')

          assert.true(typeof paramsObject.keylen === 'number', 'Check keylen type - string')
          assert.equal(paramsObject.keylen, KEYLEN, 'Check keylen value')

          assert.true(typeof paramsObject.digest === 'string', 'Check digest type - string')
          assert.equal(paramsObject.digest, DIGEST, 'Check digest value')
        }
      }
    ])
  }
}, module.parent)
