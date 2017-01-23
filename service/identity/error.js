var create = require('ut-error').define
var Policy = create('policy')
var Param = create('param', Policy)
var Password = create('password', Param)

module.exports = {
  passwordRequired: function () {
    return new Password('please provide your password')
  }
}
