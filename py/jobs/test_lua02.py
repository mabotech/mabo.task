

import time

import redis

import random




db = redis.Redis(host="127.0.0.1", port=6389, db=0)

def main():

    with open("update.lua","r") as fileh:
        
        lua_script = fileh.read()
        
        
    sha = db.script_load(lua_script)
    
    print sha

    


    key = "1"

    while True:
        
        timestamp = 1000 * time.time()
        
        val = random.randint(3,6)

        v = db.evalsha(sha,  1, key,   val, timestamp)

        print val, v

        time.sleep(2)
        
if __name__ == "__main__":
    
    main()
    