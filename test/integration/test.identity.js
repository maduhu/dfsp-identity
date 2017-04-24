var test = require('ut-run/test')
var config = require('./../lib/appConfig')
var joi = require('joi')

const TIMESTAMP = (new Date()).getTime()
const ACCOUNT_ACTOR_ID_1 = 'ActorId_1_' + TIMESTAMP
const ACCOUNT_ACTOR_ID_2 = 'ActorId_2_' + TIMESTAMP
const IDENTIFIER_1 = 'Identifier_1_' + TIMESTAMP
const IDENTIFIER_2 = 'Identifier_2_' + TIMESTAMP
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
      }
    ])
  }
}, module.parent)
