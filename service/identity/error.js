var create = require('ut-error').define
// policy
var Policy = create('policy')
var Param = create('param', Policy)
var Password = create('password', Param)
// user
var User = create('user')
var SecurityViolation = create('securityViolation', User)
var defaultErrorCode = 400

module.exports = {
  passwordRequired: function () {
    return new Password('please provide your password')
  },
  securityViolation: function () {
    return new SecurityViolation('Security violation')
  },
  error: [
    {
      type: 'identity',
      message: 'identity error'
    },
    {
      id: 'IdentityTypeMissingError',
      type: 'identity.typeMissing',
      message: 'Missing identity type',
      statusCode: 422
    }
  ].reduce((exporting, error) => {
    var typePath = error.type.split('.')
    var Ctor = create(typePath.pop(), typePath.join('.'), error.message)
    /**
     * Exceptions thrown from the db procedures will not execute this function
     * It will only be executed if an error is throw from JS
     */
    exporting[error.type] = function (params) {
      return new Ctor({
        isJsError: true,
        params: params,
        statusCode: error.statusCode || defaultErrorCode,
        id: error.id || error.type
      })
    }
    return exporting
  }, {})
}
