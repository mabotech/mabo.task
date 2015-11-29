

#import gevent

from time import strftime, localtime

def report(**data):
    
    #gevent.sleep(5)
    
    with open("a10998.txt","a") as fh:
    
        info = ">>%s : report3 Heartbeat abc(%s)\n" % (strftime("%Y-%m-%d %H:%M:%S", localtime()), data["abc"])
        print info
        fh.write(info)
    
if __name__ == "__main__":
    
    report(abc="d")