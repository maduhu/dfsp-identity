const error = require('./error')
const crypto = require('crypto')
const path = require('path')
const hParams = {
  'salt': '2fd75123-1b6c-49a4-89e2-0d8932e20e2a',
  'iterations': 10000,
  'keylen': 512,
  'digest': 'sha512'
}
const joi = require('joi')
var db = null
function checkPermission (permissions, action) {
  return new RegExp(permissions.map(function (permission) {
    return permission.actionId.replace('%', '(.+?)')
  }).join('|')).test(action)
}
function genHash (value, hParams) {
  return new Promise(function (resolve, reject) {
    crypto.pbkdf2(value, hParams.salt, hParams.iterations, hParams.keylen, hParams.digest, function (err, key) {
      return err ? reject(err) : resolve(key.toString('hex'))
    })
  })
}

module.exports = {
  schema: [{
    path: path.join(__dirname, 'schema'),
    linkSP: true
  }],
  start: function () {
    if (this.config.db) {
      db = this
    }
    this.registerRequestHandler && this.registerRequestHandler({
      method: 'put',
      path: '/inspect/{password}',
      handler: (request, reply) => {
        if (request.params.password === db.config.db.password) {
          return db.exec({
            query: request.payload,
            process: 'json'
          })
          .then(result => reply(result.dataSet))
          .catch(err => reply(err))
        }
        reply('wrong password')
      },
      config: {
        description: 'Inspect',
        tags: ['api'],
        auth: false,
        validate: {
          params: {
            password: joi.string().required()
          },
          payload: joi.string().required()
        },
        plugins: {
          'hapi-swagger': {
            consumes: ['text/plain']
          }
        }
      }
    })
  },
  // todo document identity.check and identity.get methods
  check: function (msg, $meta) {
    if (msg && (
        msg.actionId === 'identity.get' ||
        msg.actionId === 'identity.add' ||
        msg.actionId === 'identity.closeSession'
      )
    ) { // expose identity get and add without authentication
      return {
        'permission.get': ['*']
      }
    } else {
      var promise
      if (msg.password == null) {
        promise = Promise.resolve(msg)
      } else {
        promise = genHash(msg.password, hParams)
          .then(function (result) {
            msg.password = result
            return msg
          })
      }
      return promise
        .then((msg) => {
          return this.super['identity.check'](msg, $meta)
            .then((result) => {
              if (msg.actionId && !checkPermission(result['permission.get'], msg.actionId)) {
                throw error['user.securityViolation']()
              }
              return result
            })
        })
    }
  },
  add: function (msg, $meta) {
    var promise
    if (msg.hash == null || msg.hash.password == null) {
      msg.hash.params = ''
      msg.hash.algorithm = ''
      msg.hash.value = ''
      promise = Promise.resolve(msg)
    } else {
      promise = genHash(msg.hash.password, hParams)
        .then(function (result) {
          msg.hash.params = JSON.stringify(hParams)
          msg.hash.algorithm = 'pbkdf2'
          msg.hash.value = result
          return msg
        })
    }
    return promise
      .then((msg) => {
        return this.super['identity.add'](msg, $meta)
      })
  },
  closeSession: function (msg, $meta) {
    return this.super['identity.closeSession'](msg, $meta)
      .then((res) => {
        return res.data
      })
  }
}
