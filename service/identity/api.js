var joi = require('joi')
module.exports = {
  check: {
    auth: false,
    route: '/login',
    description: 'Check password',
    params: joi.object({
      username: joi.string().required(),
      password: joi.string().required(),
      timezone: joi.string(),
      actionId: joi.string()
    }),
    result: joi.object({
      'identity.check': joi.any(),
      'permission.get': joi.any(),
      person: joi.any(),
      language: joi.any()
    })
  },
  get: {
    auth: false,
    description: 'Get hash params and actorId',
    params: joi.object({
      username: joi.string().required(),
      type: joi.string()
    }),
    result: joi.object({
      'hashParams': joi.any()
    })
  },
  add: {
    auth: false,
    description: '',
    params: joi.any(),
    result: joi.any()
  }
}
