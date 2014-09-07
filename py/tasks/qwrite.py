# -*- coding: utf-8 -*-

"""queue writer"""

import nsq
import tornado.ioloop
import time

import json

addresses = ['127.0.0.1:4150']

writer = nsq.Writer(addresses)

def pub_message():
    """ pub message """
    
    data = {"time": time.strftime('%H:%M:%S')}
    
    writer.pub('test', json.dumps(data), finish_pub)

def finish_pub(conn, data):
    """ finish pub callback"""
    #print(conn)
    print ("finish,[%s]" %(data))

c = 0

def check():
    """ check """
    global c
    
    c = c +1
    
    if c % 3 == 0:
        print c
        pub_message()
    else:
        print("no msg:%s" % (c))
        
def main():    
    """ main """
    
    tornado.ioloop.PeriodicCallback(check, 2000).start()
    
    nsq.run()
    
if __name__ == "__main__":
    main()