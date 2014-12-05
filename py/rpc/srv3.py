
import os
import time

import rpyc

import socket
import gevent

import cv2

from multiprocessing import Pool

rpyc.core.protocol.DEFAULT_CONFIG['allow_pickle'] = True




def square(x):
    
    #gevent.sleep(0.2)
    #print cs

    if x == 2:
        """
        capture = cv2.VideoCapture(0)
        
        ret, img = capture.read()
        #print ret
        filename = "%s.png" % (time.time())
        cv2.imwrite(filename, img)

        """
        #return "err"
        pass
        #raise(Exception("err"))
    return os.getpid()


class MyService(rpyc.Service):
    
    
    def on_connect(self):
        self.pool = Pool(processes = 4)
        print "con"
        
    def exposed_RemotePool(self, function, arglist):

        
        result = self.pool.map(function, arglist)
        #pool.close()
        return result

    def on_disconnect(self):
        
        self.pool.close()
        
        print "dis"


if __name__ == "__main__":
    
    from rpyc.utils.server import ThreadedServer
    
    t = ThreadedServer(MyService, port = 18861, protocol_config = rpyc.core.protocol.DEFAULT_CONFIG)
    
    t.start()