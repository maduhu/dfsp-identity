var path = require('path')
module.exports = {
  id: 'httpserver',
  createPort: require('ut-port-httpserver'),
  logLevel: 'trace',
  api: ['identity'],
  imports: ['identity.start'],
  port: 8012,
  allowXFF: true,
  disableXsrf: {
    http: true,
    ws: true
  },
  bundle: 'identity',
  dist: path.resolve(__dirname, '../dist'),
  routes: {
    rpc: {
      method: '*',
      path: '/rpc/{method?}',
      config: {
        app: {
          skipIdentityCheck: true
        },
        tags: ['rpc'],
        auth: false
      }
    }
  }
}
