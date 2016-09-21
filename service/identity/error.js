var create = require('ut-error').define
var Identity = create('identity')

module.exports = {
  identity: function (cause) {
    return new Identity(cause)
  }
}
