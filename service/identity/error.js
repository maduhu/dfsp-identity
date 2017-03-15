var create = require('ut-error').define
// policy
var Policy = create('policy')
var Param = create('param', Policy)
var Password = create('password', Param)
// user
var User = create('user')
var SecurityViolation = create('securityViolation', User)

module.exports = {
  passwordRequired: function () {
    return new Password('please provide your password')
  },
  securityViolation: function () {
    return new SecurityViolation('Security violation')
  }
}
