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
      actionId: joi.string(),
      ip: joi.string(),
      // params needed for ut-port-httpserver ^8.11.0
      xsrfToken: joi.any().optional(),
      scopes: joi.any().optional(),
      exp: joi.any().optional()
    })
      .or('username', 'actionId', 'sessionId')
      .with('password', 'username')
      .with('sessionId', 'timezone', 'actorId', 'channel', 'iat')
      .unknown(),
    result: joi.object({
      'identity.check': joi.object(),
      'permission.get': joi.array(),
      person: joi.object(),
      language: joi.object(),
      localisation: joi.object(),
      roles: joi.array(),
      emails: joi.array(),
      screenHeader: joi.string().allow('')
    }).unknown()
  },
  get: {
    auth: false,
    description: 'Get hash params and actorId',
    params: joi.object({
      username: joi.string(),
      actorId: joi.string(),
      type: joi.string()
    })
    .xor('username', 'actorId')
    .with('username', 'type')
    .with('actorId', 'type'),
    result: joi.object({
      'hashParams': joi.any(),
      'roles': joi.any().allow(null)
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
  },
  'role.fetch': {
    auth: false,
    description: 'Fetch roles',
    params: joi.any(),
    result: joi.any()
  }
}
