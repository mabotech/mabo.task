

import redis
import threading
import time

import gevent 
from gevent import monkey

monkey.patch_all()

r = redis.client.StrictRedis()

now = time.time()

TIMEOUT = 3

def callback():
  
  sub = r.pubsub()
  sub.subscribe('clock')
  sub.subscribe('abc')
  
  while True:
      
    for m in sub.listen():
        
      if m["type"] == 'message':
          print m #'Recieved: {0}'.format(m['data'])
          global now
          now = time.time()
      else:
          print "channel: %s" %(m["channel"])
      #print m["data"]
 
def zerg_rush(n):
  for x in range(n):
    t = threading.Thread(target=callback)
    t.setDaemon(True)
    t.start()
 
def heartbeat():
    print "heartbeat"
    
def main():

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
            heartbeat()
            pass
            
        now = t2
        gevent.sleep(3)
        #r.publish("clock","val")
 
if __name__ == '__main__':
  main()