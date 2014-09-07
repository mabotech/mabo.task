
import zmq
import time
import sys

import msgpack

port = "5556"

context = zmq.Context()
socket = context.socket(zmq.REP)

socket.bind("tcp://*:%s" % port)

while True:
    #  Wait for next request from client
    message = socket.recv()
    
    v = msgpack.unpackb(message, encoding='utf-8')
    #print "Received request: ", message
    #time.sleep (1)  
    #socket.send("port %s" % port)
    socket.send( msgpack.packb(v))