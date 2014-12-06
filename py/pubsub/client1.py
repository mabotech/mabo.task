
#client: sent cmd and get resp.

"""
client1.py -- server1.py
start client first for it's the zmq server.

"""

import zmq
import random
import sys
import time

import threading

def worker():

    port = "5556"

    context = zmq.Context()
    socket = context.socket(zmq.PUB)
    socket.bind("tcp://*:%s" % port)

    while True:
        topic = random.randrange(9999,10005)
        messagedata = random.randrange(1,215) - 80
        print "%d %d" % (topic, messagedata)
        socket.send("%d %d" % (topic, messagedata))
        time.sleep(1)
        
def w2():
    """ timeout alert"""
    print("w2")
    context = zmq.Context()
    socket = context.socket(zmq.REP)
    socket.bind("tcp://*:%s" % 5557)
    #socket.connect ("tcp://localhost:%s" % 5557)
    while True:
        message = socket.recv()
        print(message)
        socket.send("got")
    #pass
    
def main():
    t = threading.Thread(target=worker)
    t.start()
    
    t2 = threading.Thread(target=w2)
    t2.start()
    
    
if __name__ == "__main__":
    main()