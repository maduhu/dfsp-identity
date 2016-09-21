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
  }
}
