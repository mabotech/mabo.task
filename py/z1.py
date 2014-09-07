# -*- coding: utf-8 -*-

import zmq
import time
import msgpack

context = zmq.Context()

#  Socket to talk to server
print("Connecting to hello world server")
socket = context.socket(zmq.REQ)
socket.connect("tcp://localhost:5556")

#  Do 10 requests, waiting each time for a response



start =  time.time()

message = None

for request in range(10000):
    #print("Sending request %s …" % request)
    
    msgpacked = msgpack.packb([b'spam', u'egg'])
    
    socket.send(msgpacked)

    #  Get the reply.
    message = socket.recv()
    
    msg = msgpack.unpackb(message, encoding='utf-8')
    #print("Received reply %s [ %s ]" % (request, message))

print msg

dt = time.time() - start

v =  10000 /dt

print v

print 1000/v