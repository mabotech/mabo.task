
import redis

r = redis.client.StrictRedis()

for i in range(0,2):
    r.publish("clock","{abc:def}")
    r.publish("abc","{abc:aaa}")