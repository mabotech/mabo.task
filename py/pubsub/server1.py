# video server

import sys

import multiprocessing
import zmq

port = "5556"


# Socket to talk to server
def worker(topicfilter):
    
    context = zmq.Context()

    socket = context.socket(zmq.SUB)

    socket.connect ("tcp://localhost:%s" % port)
       
    # Subscribe to zipcode, default is NYC, 10001
    #topicfilter = "10001"
    socket.setsockopt(zmq.SUBSCRIBE, topicfilter)
    
    #===========
    context2 = zmq.Context()
    print "Connecting to server with ports %s" % 5557
    socket2 = context2.socket(zmq.REQ)
    socket2.connect ("tcp://localhost:%s" % 5557)
    
    
    # Process 5 updates
    #total_value = 0
    #for update_nbr in range (5):
    while True:
        string = socket.recv()
        topic, messagedata = string.split()
        socket2.send ("Hello"+topic)
        message = socket2.recv()
        print(message)
        print topic, messagedata
        
        

def create_processes():
    
    for i in range(1):
        f = "%s" %(10000 + i)
        process = multiprocessing.Process(target=worker, args=(f,))
        process.daemon = True
        process.start()
        
        
def main():
    print("main")
    create_processes()
    import time
    time.sleep(100)

    
    
if __name__ == "__main__":
    
    main()