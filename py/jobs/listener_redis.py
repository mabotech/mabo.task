
"""
server side redis listener.
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

with open("heartbeat.lua", "r") as fileh:

    lua_script = fileh.read()

sha = db.script_load(lua_script)

# print sha


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

                        del data["time"]
                        del data["time_precision"]

                        # print data
                        post(data)

                    except Exception as ex:
                        print "exception:", ex
            else:
                # print "channel: %s" %(m["channel"])
                pass


def new_thread():
    """ new thread """

    t = threading.Thread(target=callback)

    t.setDaemon(True)

    t.start()


def check_heartbeat():
    """ 
    check heartbeat by lua in redis
    and update etcd
    """

    name = conf["NAME"]

    etc.write("/heartbeat/%s" % (name), 1, ttl=conf["SLEEP"])

    collectors = conf["COLLECTORS"]

    now = 1000 * time.time()

    for key in collectors:

        status = db.evalsha(sha, 1, key, now, 1000 * conf["SLEEP"])

        if status == "On":

            etc.write("/heartbeat/%s" % (key), 1, ttl=conf["SLEEP"])


def main():
    """ main """

    new_thread()

    pool = Pool(3)

    while True:

        pool.spawn(check_heartbeat)

        gevent.sleep(conf["SLEEP"])


if __name__ == '__main__':

    main()
