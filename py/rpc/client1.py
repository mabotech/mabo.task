
import socket
import gevent
import rpyc

import time

def work(c):
    
    #print dir(c)
    
    v = c.root.get_answer()

    print v

    v2 = c.root.get_question("Cindy")

    print v2
    
def main():
    c = rpyc.connect("localhost", 18861)

    for i in range(0,4):
        gevent.sleep(0.1)
        work(c)
    c.close()
    
if __name__ == "__main__":
    t1 = time.time()
    main()
    print time.time() - t1