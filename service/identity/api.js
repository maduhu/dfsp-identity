var joi = require('joi')

module.exports = {
  check: {
    auth: false,
    route: '/login',
    description: 'Check password',
    params: joi.object({
      username: joi.string(),
      password: joi.string(),
      sessionId: joi.string(),
      timezone: joi.string(),
      actorId: joi.string(),
      channel: joi.string(),
      iat: joi.number(),
      actionId: joi.string()
    })
      .or('username', 'actionId', 'sessionId')
      .with('password', 'username')
      .with('sessionId', 'timezone', 'actorId', 'channel', 'iat'),
    result: joi.object({
      'identity.check': joi.object(),
      'permission.get': joi.array(),
      person: joi.object(),
      language: joi.object(),
      localisation: joi.object(),
      roles: joi.array(),
      emails: joi.array(),
      screenHeader: joi.string().allow('')
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
  },
  closeSession: {
    auth: false,
    description: '',
    params: joi.any(),
    result: joi.any()
  }
}
