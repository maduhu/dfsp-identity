var joi = require('joi')
module.exports = {
  check: {
    description: 'Check password',
    params: joi.object({
      username: joi.string().required(),
      password: joi.string().required()
    }),
    result: joi.object({
      'identity.check': joi.any(),
      'permission.get': joi.any(),
      person: joi.any(),
      language: joi.any()
    })
  },
  get: {
    description: 'Get hash params and actorId',
    params: joi.object({
      username: joi.string().required(),
      type: joi.string()
    }),
    result: joi.object({
      'hashParams': joi.any()
    })
  }
}
