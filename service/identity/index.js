const crypto = require('crypto')
const path = require('path')
const hParams = {
  'salt': '2fd75123-1b6c-49a4-89e2-0d8932e20e2a',
  'iterations': 100000,
  'keylen': 512,
  'digest': 'sha512'
}

module.exports = {
  schema: [{
    path: path.join(__dirname, 'schema'),
    linkSP: true
  }],
  // todo document identity.check and identity.get methods
  check: function (msg, $meta) {
    if (msg && msg.actionId === 'identity.get') { // expose identity.get without authentication
      return {
        'permission.get': ['*']
      }
    } else {
      return new Promise((resolve, reject) => {
        if (msg.password == null) {
          resolve(msg)
        } else {
          crypto.pbkdf2(msg.password, hParams.salt, hParams.iterations, hParams.keylen, hParams.digest, (err, key) => {
            if (err) {
              throw err
            }
            msg.password = key.toString('hex')
            resolve(msg)
          })
        }
      }).then((msg) => {
        return this.super['identity.check'](msg, $meta)
      })
    }
  }
}
