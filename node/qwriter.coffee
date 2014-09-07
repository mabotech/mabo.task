
# nsq writer

{Writer} = require 'nsqjs'

w = new Writer '127.0.0.1', 4150

w.connect()

w.on Writer.READY, ->
  # Send a single message
  w.publish 'test', 'it really tied the room together'
  
  w.publish 'test', ['Uh, excuse me. Mark it zero. Next frame.', 
    'Smokey, this is not \'Nam. This is bowling. There are rules.']
    
  w.publish 'test', 'Wu?', (err) ->
    console.log 'Message sent successfully' unless err?
    
  w.close()
  
w.on Writer.CLOSED, ->
  console.log 'Writer closed'