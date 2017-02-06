module.exports = {
  id: 'api',
  createPort: require('ut-port-jsonrpc'),
  url: 'http://localhost:8010',
  namespace: ['directory'],
  logLevel: 'debug',
  method: 'post'
}
