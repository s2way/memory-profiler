# expected params
# coffee profiler.coffee {PID} {appName}

es_host =
    host: 'localhost'
    port: 9200

SystemInfo = require('waferpie-utils').SystemInfo
ElasticSearch = require 'elasticsearch-connector'
es = new ElasticSearch es_host
systemInfo = new SystemInfo process.argv[4] or 'app', process.argv[2]
setInterval ->
    info = systemInfo.gather()
    info.created = new Date().toISOString()
    info.name = process.argv[4] or 'app'
    log =
        index: 'microservices'
        type: 'log'
        data: info
    es.create log, (error, success, status) ->
        return console.log error if [200, 201].indexOf(status) is -1
, process.argv[3] or 3000