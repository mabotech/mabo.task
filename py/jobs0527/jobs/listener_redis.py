
"""
server side redis listener.

- logging
- exception handling

"""
import os
import sys


import toml

import msgpack



import redis
import threading
import time

import etcd

import gevent
from gevent.pool import Pool
from gevent import monkey


monkey.patch_all()

from utils.ws_post import post
from multi_logging import get_logger



#conf_fn = os.sep.join(
#    [os.path.split(os.path.realpath(__file__))[0], "listener.toml"])

# print conf_fn

conf_fn = "config/listener_redis.toml"

with open(conf_fn) as conf_fh:

    cfg = toml.loads(conf_fh.read())

    conf = cfg["redis"]
    etcd_cfg = cfg["etcd"]
    
## 

with open(conf["logging_config"], "r") as fh:
    
    json_str = fh.read() 

conf_json = json.loads(json_str)

logger = get_logger(conf["log_base"], conf["app_name"], conf_json)

logger.debug(conf)

## 

# " ""
db = redis.client.StrictRedis(
    host=conf["HOST"],
    port=conf["PORT"],
    db=conf["DB"])
# " ""

## pool
#db = 

etc = etcd.Client(host=etcd_cfg["HOST"], port=etcd_cfg["PORT"])


lua_file = conf["HEARTBEAT_LUA"]

#print lua_file

with open(lua_file, "r") as fileh:

    lua_script = fileh.read()
    

sha = db.script_load(lua_script)

# print sha

def strict_time():
    if sys.platform == "win32":
        return time.clock()
    else:
        return time.time()




def callback():
    """ run in thread """

    sub = db.pubsub()

    channels = ['new_data']

    for channel in channels:

        sub.subscribe(channel)

    while True:

        for msg in sub.listen():

            if msg["type"] == 'message':

                queue_len = db.llen("data_queue")
                print queue_len
                for i in xrange(0, queue_len):
                    v = db.lpop("data_queue")
                    print v
                    if v != None:
                        data = msgpack.unpackb(v)
                    else:
                        continue
                    # print queue_len, data

                    try:

                        #print data

                        #del data["heartbeat"]
                        #del data["time_precision"]
                        
                        if "ch_occupied" in data:

                            data = {"id":data["id"], "ch_occupied":data["ch_occupied"]}
                            
                        else:
                            data = {"id":data["id"], "ch_ori_eqpt":data["ch_ori_eqpt"]}
                        
                        post(data)

                    except Exception as ex:
                        #print "post data exception:", ex
                        pass
            else:
                # print "channel: %s" %(m["channel"])
                pass


def new_thread():
    """ new thread """

    t = threading.Thread(target=callback)

    t.setDaemon(True)

    t.start()

def etcd_write(key, value):

    etc.write("/heartbeat/%s" % (key), value, ttl=conf["SLEEP"])
    
def check_heartbeat():
    """ 
    check heartbeat by lua in redis
    and update etcd
    
    if no etcd?
    
    """

    name = conf["NAME"]

    etcd_write(name)

    collectors = conf["COLLECTORS"]

    now = 1000 * time.time()

    for key in collectors:
        
        #print now
        #print 1000 * conf["SLEEP"]
        
        status = db.evalsha(sha, 1, key, now, 1000 * conf["SLEEP"])
        
        logger.debug( "%s heartbeat: %s" % (key, status) )

        if status == "On":
            
            etcd_write(key, status)
            #etc.write("/heartbeat/%s" % (key), 1, ttl=conf["SLEEP"])

#

def main():
    """ main loop """
    
    new_thread()

    pool = Pool(conf["POOL_SIZE"])

    while True:
        
        try:
        
            pool.spawn(check_heartbeat)
            
        except Exception as ex:
            
            logger.error(ex)
            
        gevent.sleep(conf["SLEEP"])


if __name__ == '__main__':

    main()
