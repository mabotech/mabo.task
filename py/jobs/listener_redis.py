
"""
server side redis listener.
"""

import redis
import threading
import time

import gevent 
from gevent import monkey

monkey.patch_all()

r = redis.client.StrictRedis()

now = time.time()

TIMEOUT = 3


def post(data):
    """   """
    pass
    

def callback():
  
  sub = r.pubsub()
  
  channels = ['clock','abc']
  
  for channle in channels:
      
    sub.subscribe(channel)
  
  while True:
      
    for m in sub.listen():
        
      if m["type"] == 'message':
          print m #'Recieved: {0}'.format(m['data'])
          global now
          now = time.time()
      else:
          print "channel: %s" %(m["channel"])
      #print m["data"]
 
def new_thread():
    """   """
    
    t = threading.Thread(target=callback)
    t.setDaemon(True)
    t.start()
 
def heartbeat():
    """   """
    print "heartbeat"
    
def timeout():
    """ 
    heartbeat  
    timeout_count
    """
    
    print "timeout"
    
def main():
    """    """
    
    global now

    t = threading.Thread(target=callback)
    t.setDaemon(True)
    t.start()

    while True:
        #print 'Waiting'
        t2 = time.time()
        #print "diff", t2-now
        
        if t2-now >= TIMEOUT:
            #print "timeout"
            timeout()
            pass
            
        now = t2
        gevent.sleep(3)
        #r.publish("clock","val")
 
if __name__ == '__main__':
    
    main()
    
    