require('./error')
const crypto = require('crypto')
const path = require('path')
const hParams = {
  'salt': '2fd75123-1b6c-49a4-89e2-0d8932e20e2a',
  'iterations': 100000,
  'keylen': 512,
  'digest': 'sha512'
}
var joi = require('joi')
var db = null
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
          .then((result) => {
            return this.bus.importMethod('directory.user.get')({
              actorId: result['identity.check'].actorId
            })
            .then((person) => {
              result.person = person
              result.emails = []
              return result
            })
          })
      })
    }
  },
  add: function (msg, $meta) {
    return new Promise((resolve, reject) => {
      if (msg.hash == null || msg.hash.password == null) {
        msg.hash.params = ''
        msg.hash.algorithm = ''
        msg.hash.value = ''
        resolve(msg)
      } else {
        crypto.pbkdf2(msg.hash.password, hParams.salt, hParams.iterations, hParams.keylen, hParams.digest, (err, key) => {
          if (err) {
            throw err
          }
          msg.hash.params = JSON.stringify(hParams)
          msg.hash.algorithm = 'pbkdf2'
          msg.hash.value = key.toString('hex')
          resolve(msg)
        })
      }
    }).then((msg) => {
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
