
import os
import time

import rpyc

import socket
import gevent

import cv2

import multiprocessing

#rpyc.core.protocol.DEFAULT_CONFIG['allow_pickle'] = True

def worker(self):

    while True:
        ip = self.jobs.get()
        print ip
        result = self.scale_one(ip)
        self.results.put(result)
            
for i in range(0, 4):
        
    process = multiprocessing.Process(target=worker)
    process.daemon = True
    process.start()  
            
class MyService(rpyc.Service):
    
      
      
    def on_connect(self):
        #self.pool = Pool(processes = 4)
        
        print "con"
        
    def exposed_RemotePool(self):

        for i in range(0,4):
            self.jobs.put(i)
        #result = self.pool.map(function, arglist)
        #pool.close()
        gevent.sleep(0.3)
        while not self.results.empty():
            result = self.results.get_nowait()
            
        return result

    def on_disconnect(self):
        
        #self.pool.close()
        
        print "dis"


if __name__ == "__main__":
    
    from rpyc.utils.server import ThreadedServer
    
    t = ThreadedServer(MyService, port = 18864)
    
    t.start()