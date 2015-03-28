
"""
server side redis listener.
"""
import os, sys

import json
import toml

import msgpack

import requests

import redis
import threading
import time

import etcd

import gevent 
from gevent.pool import Pool
from gevent import monkey

import random

monkey.patch_all()


conf_fn = os.sep.join([os.path.split(os.path.realpath(__file__))[0],"listener.toml"])

#print conf_fn

with open(conf_fn) as conf_fh:
    
    cfg = toml.loads(conf_fh.read())
    
    conf = cfg["redis"]
    etcd_cfg = cfg["etcd"]


db = redis.client.StrictRedis(host=conf["HOST"], port=conf["PORT"], db=conf["DB"])


etc = etcd.Client(host=etcd_cfg["HOST"], port=etcd_cfg["PORT"])

#now = time.time()

#TIMEOUT = 3

with open("heartbeat.lua","r") as fileh:
    
    lua_script = fileh.read()
    
    
sha = db.script_load(lua_script)

#print sha

def post(data):
    
    print data

    URL =  conf["JSONRPC"] #'http://127.0.0.1:6226/api/v1/callproc.call'
    
    #mtp_update_equipemnt_cs1
    payload = {
                "jsonrpc":"2.0",
                "id":"r2",
                "method":"call",
                "params":
                {
                    "method":conf["METHOD"],
                    "table":conf["TABLE"], 
                    "pkey": conf["PKEY"],
                    "columns":data,
                   "context":{"user":"mt", "languageid":"1033", "sessionid":"123" } 
               }
            }
            
    HEADERS = {'content-type': 'application/json', 'accept':'json','User-Agent':'mabo'}
    #headers = HEADERS
    #headers = {'Accept':'json'}
    payload = json.dumps(payload)
    
    #print payload
    
    resp = requests.post(URL, data = payload , headers=HEADERS)
    
    s = resp.text#.encode("utf8")
    
    v = json.loads(s)
    
    if v.has_key("error"):
        print s.encode("utf8")

def callback():
  """ run in thread """
  
  sub = db.pubsub()
  
  channels = ['new_data']
  
  for channel in channels:
      
    sub.subscribe(channel)
  
  while True:
      
    for msg in sub.listen():
        
      if msg["type"] == 'message':
          #print m #'Recieved: {0}'.format(msg['data'])
          #global now
          #now = time.time()
          
          #print msg['data']
          
          queue_len = db.llen("data_queue")
          
          for i in xrange(0, queue_len):
                v = db.lpop("data_queue")
                data = msgpack.unpackb(v)
                #print queue_len, data
              
                try:
                    #data = {"id":data["id"],"api":data["api"]}
                    
                    print data
                    
                    del data["time"]
                    del data["time_precision"]
                    
                    #print data
                    post(data)
                
                except Exception as ex:
                    print "exception:", ex
          
          #data = msg['data']
          
          #data = msgpack.unpackb(msg['data'])
          
          
      else:
          #print "channel: %s" %(m["channel"])
          pass
      #print m["data"]
 
def new_thread():
    """ new thread """
    
    t = threading.Thread(target=callback)
    
    t.setDaemon(True)
    
    t.start()
 
def heartbeat():
    """ heartbeat """
    
    """
    try:
        with gevent.Timeout(1, Exception("timeout here ")) as timeout:
            gevent.sleep(2)
    except Exception as ex:
        print ex
    """
    
    #data = {"key":random.randint(1,100),"val":123}
    
    #db.publish("clock",msgpack.packb(data) )
    
    check_heartbeat()
    
def write(data):
    """ """
    etc.write("/v1",1)
    
    
def check_heartbeat():
    """ v2 """
    
    name = conf["NAME"]
    
    etc.write("/heartbeat/%s" %(name), 1, ttl = conf["SLEEP"] )
    
    collectors = conf["COLLECTORS"]    
        
    for key in collectors:
        
        """
        db.hset(key,"val", random.randint(1,100))
        db.hset(key,"time_precision", "ms")
        db.hset(key,"time",1000*time.time())
        """
        #print r.hkeys("abc")
        
        # get heartbeat of collector
        #
        
        now = 1000*time.time()
        """
        dt = db.hgetall(key)
        
        #print dt
        
        v =  now - float(dt["time"])
        
        
        if v < 1000 * conf["SLEEP"] :
        
            
            

        else:
            
        """    
        #print type(now)
        #print type( 1000 * conf["SLEEP"])
        
        status = db.evalsha(sha, 1, key, now, 1000 * conf["SLEEP"])
        
        if status == "On":
            
            etc.write("/heartbeat/%s" %(key), 1, ttl = conf["SLEEP"])
            
        """
        if dt["off"] == '0':
            
            db.hset(key,"off",'1') 
        
            data = {"id":key, "api":"0"} # 0 for off.
        
            post(data)
        """
        ## etcd.write()    
    
    #print "heartbeat"
    
def timeout():
    
    """ 
    heartbeat  
    timeout_count
    """
    
    print "timeout"
    
def main():
    """    """
    
    #global now
    """
    t = threading.Thread(target=callback)
    t.setDaemon(True)
    t.start()
    """
    
    new_thread()
    
    
    pool = Pool(10)
    
    while True:
        #print 'Waiting'
        """
        t2 = time.time()
        #print "diff", t2-now
        
        
        if t2-now >= TIMEOUT:
            #print "timeout"
            #timeout()
            pass
            
        now = t2
        """
        #t1 = time.time()
        
        ## timeout handle
        ## pool.
        
        #gevent.spawn(heartbeat)
        
        #heartbeat()
        #timeout = gevent.Timeout(1)
        #timeout.start()
        #try:
            
            #with gevent.Timeout(1, Exception("timeout 000")) as timeout:
                
        pool.spawn(check_heartbeat)
            
        #print "free_count: %s" % ( pool.free_count() ) 
            
        #except Exception as ex:
        #    print "ex 0000:", ex
        #finally:
        #    timeout.cancel()
            
        gevent.sleep(conf["SLEEP"])
        
        #print time.time() - t1
        
        #r.publish("clock","val")
 
if __name__ == '__main__':
    
    main()
    
    