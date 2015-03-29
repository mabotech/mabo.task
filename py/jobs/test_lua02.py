
import os, sys

import time
import redis
import random

import socket
import gevent
from gevent.pool import Pool
from gevent import monkey

monkey.patch_all()

db = redis.Redis(host="127.0.0.1", port=6389, db=0)

with open("update.lua","r") as fileh:
    
    lua_script = fileh.read()
    
    
sha = db.script_load(lua_script)
    
    
def strict_time():
    if sys.platform == "win32":
        return time.clock()
    else:
        return time.time()

def set(key, i):
    
    timestamp = 1000 * time.time()
    
    val = random.randint(1,4)

    v = db.evalsha(sha,  1, key, val, timestamp)

    print "[%s] %s,%s" %(i, val, v)
    
def main():


    print sha  


    keys = ["1","2","3"]
    
    pool = Pool(10)
    
    i = 0
    
    while True:
        i = i +1
        for key in keys:
            pool.spawn(set, key, i)
        
        #set(key)

        time.sleep(2)
        
if __name__ == "__main__":
    
    main()
    