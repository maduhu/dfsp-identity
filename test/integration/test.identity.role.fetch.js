var test = require('ut-run/test')
var config = require('./../lib/appConfig')
const PUBLIC_ROLES = ['customer', 'merchant', 'agent']
const NOT_PUBLIC_ROLES = ['common', 'maker', 'checker']

test({
  type: 'integration',
  name: 'DFSP identity test',
  server: config.server,
  serverConfig: config.serverConfig,
  client: config.client,
  clientConfig: config.clientConfig,
  steps: function (test, bus, run) {
    run(test, bus, [
      {
        name: 'Fetch public roles',
        method: 'identity.role.fetch',
        params: (context) => {
          return {
            isPublic: true
          }
        },
        result: (result, assert) => {
          result.forEach((record) => {
            assert.true(typeof record.roleId === 'number', 'Check roleId type')
            assert.true(typeof record.name === 'string', 'Check role name type')
            assert.true(PUBLIC_ROLES.indexOf(record.name) > -1, 'Check that returned roles are from the public ones')
          })
        }
      },
      {
        name: 'Fetch not public roles',
        method: 'identity.role.fetch',
        params: (context) => {
          return {
            isPublic: false
          }
        },
        result: (result, assert) => {
          result.forEach((record) => {
            assert.true(typeof record.roleId === 'number', 'Check roleId type')
            assert.true(typeof record.name === 'string', 'Check role name type')
            assert.true(NOT_PUBLIC_ROLES.indexOf(record.name) > -1, 'Check that returned roles are not from the public ones')
          })
        }
      },
      {
        name: 'Fetch all roles',
        method: 'identity.role.fetch',
        params: (context) => {
          return {}
        },
        result: (result, assert) => {
          result.forEach((record) => {
            assert.true(typeof record.roleId === 'number', 'Check roleId type')
            assert.true(typeof record.name === 'string', 'Check role name type')
            assert.true((NOT_PUBLIC_ROLES.indexOf(record.name) > -1 || PUBLIC_ROLES.indexOf(record.name) > -1), 'Check that returned roles are without rule')
          })
        }
      }
    ])
  }
}, module.parent)
