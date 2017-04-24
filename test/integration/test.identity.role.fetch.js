var test = require('ut-run/test')
var config = require('./../lib/appConfig')
const ROLES = ['common', 'maker', 'checker']

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
        name: 'Fetch all roles',
        method: 'identity.role.fetch',
        params: (context) => {
          return {}
        },
        result: (result, assert) => {
          result.forEach((record) => {
            assert.true(typeof record.roleId === 'number', 'Check roleId type')
            assert.true(typeof record.name === 'string', 'Check role name type')
            assert.true((ROLES.indexOf(record.name) > -1), 'Check that returned roles are without rule')
          })
        }
      }
    ])
  }
}, module.parent)
