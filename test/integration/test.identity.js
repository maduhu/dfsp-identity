var test = require('ut-run/test')
var joi = require('joi')

test({
  type: 'integration',
  name: 'Identity service',
  client: require('../client'),
  clientConfig: require('../client/test'),
  steps: function (test, bus, run) {
    run(test, bus, [{
      name: 'Check identity',
      method: 'identity.get',
      params: {
        username: '0122523365225',
        type: 'ussd'
      },
      result: (result, assert) => {
        assert.equals(joi.validate(result, {
          actorId: joi.string(),
          hashParams: joi.any()
        }).error, null, 'return identity')
      }
    }, {
      name: 'Check pin',
      method: 'identity.check',
      params: {
        username: '0122523365225',
        password: '123'
      },
      result: (result, assert) => {
        assert.equals(joi.validate(result, {
          'identity.check': joi.object().keys({
            actorId: joi.string(),
            sessionId: joi.string()
          }),
          'permission.get': joi.array(),
          person: joi.object(),
          language: joi.object(),
          localisation: joi.object(),
          roles: joi.array(),
          emails: joi.array(),
          screenHeader: joi.string().allow('')
        }).error, null, 'check password and return identity and permissions')
      }
    }])
  }
})
