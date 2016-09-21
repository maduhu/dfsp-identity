module.exports = {
  ports: [
    require('../db'),
    require('../httpserver')
  ],
  modules: {
    identity: require('../service/identity')
  },
  validations: {
    identity: require('../service/identity/api')
  }
}
