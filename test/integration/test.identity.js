var test = require('ut-run/test')
var joi = require('joi')

test({
  type: 'integration',
  name: 'Identity service',
  client: require('../client'),
  clientConfig: require('../client/test'),
  steps: function (test, bus, run) {
    run(test, bus, [{
      name: 'Check pin',
      method: 'identity.check',
      params: {
        username: '0122523365225',
        password: '123'
      },
      result: (result, assert) => {
        assert.equals(joi.validate(result, {
          'identity.check': joi.array().length(1).items(
            joi.object({actorId: joi.string().required()})
          ),
          'permission.get': joi.any(),
          person: joi.any(),
          language: joi.any()
        }).error, null, 'return user name, account and currency')
      }
    }])
  }
})
