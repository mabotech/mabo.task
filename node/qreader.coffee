nsq = require 'nsqjs'

topic = 'test'
channel = 'coffee'
options =
  lookupdHTTPAddresses: '127.0.0.1:4161'

reader = new nsq.Reader topic, channel, options
reader.connect()

reader.on nsq.Reader.MESSAGE, (msg) ->
  console.log "Received message [#{msg.id}]: #{msg.body.toString()}"
  msg.finish()