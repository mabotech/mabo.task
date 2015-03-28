

import socket
import gevent

import random

from gevent import monkey

monkey.patch_all()

import time

import threading


def s1():
    
    
    j = 0
    
    
    v = ["c1","c2","c3","v3","v3","v3"]
    
    while True:      
        
        length = len(v)
        
        #print j % l
        
        i = random.randint(1, 5)
        
        t = time.time()
        
        k = v[j%length]
        
        #print("sleep:%s" %(i) )
        j = j + 1
        
        gevent.sleep(i)
        
        
def new_thread():
    """ new thread """
    
    t = threading.Thread(target=s1)
    
    t.setDaemon(True)
    
    t.start()        
        
def s2():

    new_thread()

    while True:        
        
        #i = random.randint(1, 10)    
        #print("main:3")
        gevent.sleep(3)
        
        
        
if __name__ == "__main__":
    
    s2()
        