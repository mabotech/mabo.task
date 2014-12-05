
import time

import rpyc

import cv2

class MyService(rpyc.Service):
    
    """   """
    
    def on_connect(self):
        # code that runs when a connection is created
        # (to init the serivce, if needed)
        print "=="*20
        print "init"
        self.capture = cv2.VideoCapture(0)
        pass

    def on_disconnect(self):
        # code that runs when the connection has already closed
        # (to finalize the service, if needed)
        print "dis"
        pass
        
    def exposed_get_answer(self): # this is an exposed method
        print "answer"
        ret, img = self.capture.read()
        filename = "%s.png" % (time.time())
        cv2.imwrite(filename, img)
        return ret
        
    def exposed_get_question(self, name):  # while this method is not exposed
        print "question"
        return "%s: what is the airspeed velocity of an unladen swallow?" %(name)
        
    def get_question(self, name):  # while this method is not exposed
        print "question"
        return "%s: what is the airspeed velocity of an unladen swallow?" %(name)
        
        
if __name__ == "__main__":
    
    from rpyc.utils.server import ThreadedServer
    
    t = ThreadedServer(MyService, port = 18861)
    
    print("start rpc server")
    
    t.start()        