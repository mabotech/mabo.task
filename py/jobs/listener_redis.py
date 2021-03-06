
"""
server side redis listener.

- logging
- exception handling

"""
import os
import sys

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


monkey.patch_all()


conf_fn = os.sep.join(
    [os.path.split(os.path.realpath(__file__))[0], "listener.toml"])

# print conf_fn

with open(conf_fn) as conf_fh:

    cfg = toml.loads(conf_fh.read())

    conf = cfg["redis"]
    etcd_cfg = cfg["etcd"]

db = redis.client.StrictRedis(
    host=conf["HOST"],
    port=conf["PORT"],
    db=conf["DB"])

etc = etcd.Client(host=etcd_cfg["HOST"], port=etcd_cfg["PORT"])


lua_file = conf["HEARTBEAT_LUA"]

print lua_file

with open(lua_file, "r") as fileh:

    lua_script = fileh.read()
    

sha = db.script_load(lua_script)

# print sha

def strict_time():
    if sys.platform == "win32":
        return time.clock()
    else:
        return time.time()

def post(data):

    print data

    URL = conf["JSONRPC"]

    payload = {
        "jsonrpc": "2.0",
        "id": "r2",
        "method": "call",
        "params": {
            "method": conf["METHOD"],
            "table": conf["TABLE"],
            "pkey": conf["PKEY"],
            "columns": data,
            "context": {
                "user": "mt",
                "languageid": "1033",
                "sessionid": "123"}}}

    HEADERS = {
        'content-type': 'application/json',
        'accept': 'json',
        'User-Agent': 'mabo'}

    payload = json.dumps(payload)
    
    resp = requests.post(URL, data=payload, headers=HEADERS)

    s = resp.text  # .encode("utf8")

    v = json.loads(s)

    if "error" in v:
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

                queue_len = db.llen("data_queue")

                for i in xrange(0, queue_len):
                    v = db.lpop("data_queue")
                    data = msgpack.unpackb(v)
                    # print queue_len, data

                    try:

                        print data

                        #del data["heartbeat"]
                        #del data["time_precision"]

                        data = {"id":data["id"], "ch_ori_eqpt":data["ch_ori_eqpt"]}
                        post(data)

                    except Exception as ex:
                        print "post data exception:", ex
            else:
                # print "channel: %s" %(m["channel"])
                pass


def new_thread():
    """ new thread """

    t = threading.Thread(target=callback)

    t.setDaemon(True)

    t.start()

def etcd_write(key):
    
    etc.write("/heartbeat/%s" % (key), 1, ttl=conf["SLEEP"])
    
    pass
    
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
        
        print now
        print 1000 * conf["SLEEP"]
        # 
        status = db.evalsha(sha, 1, key, now, 1000 * conf["SLEEP"])
        
        print "%s heartbeat: %s" % (key, status)

        if status == "On":
            
            etcd_write(key)
            #etc.write("/heartbeat/%s" % (key), 1, ttl=conf["SLEEP"])


def main():
    """ main """

    new_thread()

    pool = Pool(conf["POOL_SIZE"])

    while True:

        pool.spawn(check_heartbeat)
        #print "1"
        gevent.sleep(conf["SLEEP"])


if __name__ == '__main__':

    main()
