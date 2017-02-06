module.exports = {
  ports: [
    require('../db'),
    require('../httpserver'),
    require('../httpclient')
  ],
  modules: {
    identity: require('../service/identity')
  },
  validations: {
    identity: require('../service/identity/api')
  }
}
