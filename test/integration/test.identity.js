var test = require('ut-run/test')
var config = require('./../lib/appConfig')
var joi = require('joi')

const TIMESTAMP = (new Date()).getTime()
const ACCOUNT_ACTOR_ID_1 = 'ActorId_1_' + TIMESTAMP
const ACCOUNT_ACTOR_ID_2 = 'ActorId_2_' + TIMESTAMP
const ACCOUNT_ACTOR_ID_NEGATIVE = 'ActorId-' + TIMESTAMP
const IDENTIFIER_1 = 'Identifier_1_' + TIMESTAMP
const IDENTIFIER_2 = 'Identifier_2_' + TIMESTAMP
const IDENTIFIER_NEGATIVE = 'Id-' + TIMESTAMP
const PASSWORD_1 = 'pass_1_' + TIMESTAMP
const PASSWORD_2 = 'pass_2_' + TIMESTAMP

test({
  type: 'integration',
  name: 'DFSP identity test',
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
            }
          }
        },
        result: (result, assert) => {
          assert.deepEquals(
            result,
            {
              actor: [{ 'actorId': ACCOUNT_ACTOR_ID_1 }]
            },
            'hash #1 successfully added'
          )
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
            }
          }
        },
        result: (result, assert) => {
          assert.deepEquals(
            result,
            {
              actor: [{ 'actorId': ACCOUNT_ACTOR_ID_2 }]
            },
            'hash #2 successfully added'
          )
        }
      },
      {
        name: 'Add hash - missing password',
        method: 'identity.add',
        params: (context) => {
          return {
            hash: {
              actorId: ACCOUNT_ACTOR_ID_NEGATIVE,
              type: 'password',
              identifier: IDENTIFIER_NEGATIVE
            }
          }
        },
        result: (result, assert) => {
          assert.equals(joi.validate(result.actor, joi.array().items({
            actorId: joi.string()
          })).error, null, 'Validate identity.add object - missing password')
        }
      },
      {
        name: 'Test check',
        method: 'identity.check',
        params: (context) => {
          return {
            actorId: ACCOUNT_ACTOR_ID_1,
            username: IDENTIFIER_1,
            password: PASSWORD_1
          }
        },
        result: (result, assert) => {
          assert.equals(joi.validate(result['identity.check'], joi.object().keys({
            actorId: joi.string(),
            sessionId: joi.string().guid()
          })).error, null, 'Validate identity.check object')

          assert.equals(joi.validate(result['permission.get'], joi.array().items({
            actionId: joi.string(),
            objectId: joi.string(),
            description: joi.string()
          })).error, null, 'Validate permission.get object')

          assert.equals(joi.validate(result['language'], joi.object().keys({
            iso2Code: joi.string()
          })).error, null, 'Validate language object')

          assert.equals(joi.validate(result['localisation'], joi.object().keys({
            dateFormat: joi.string(),
            numberFormat: joi.string().allow([null, ''])
          })).error, null, 'Validate localisation object')

          assert.equals(result['roles'][0], 'common', 'Check that common role is assigned')
        }
      },
      {
        name: 'Test check - negative',
        method: 'identity.check',
        params: (context) => {
          return {
            username: IDENTIFIER_1,
            password: PASSWORD_1,
            actionId: '11'
          }
        },
        error: (error, assert) => {
          assert.equals(error.errorPrint, 'Security violation', 'Check security violation error')
        }
      },
      {
        name: 'Test check - negative missing pass',
        method: 'identity.check',
        params: (context) => {
          return {
            username: IDENTIFIER_1,
            actionId: '11'
          }
        },
        error: (error, assert) => {
          assert.equals(error.errorPrint, 'policy.param.password', 'Check missing password')
        }
      },
      {
        name: 'Identity check - permissions get',
        method: 'identity.check',
        params: (context) => {
          return {
            actionId: 'identity.get'
          }
        },
        result: (result, assert) => {
          assert.equals(joi.validate(result, joi.object().keys({
            'permission.get': joi.array()
          })).error, null, 'Validate permission.get[*]')
        }
      },
      {
        name: 'Identity close session',
        method: 'identity.closeSession',
        params: (context) => {
          return {
            actionId: 'identity.get'
          }
        },
        result: (result, assert) => {
          assert.true(result.length === 0, 'Check that the session is closed')
        }
      }
    ])
  }
}, module.parent)
