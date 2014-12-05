
import os
import time

import rpyc

import socket
import gevent

import cv2

import  multiprocessing

rpyc.core.protocol.DEFAULT_CONFIG['allow_pickle'] = True



jobs = multiprocessing.JoinableQueue()

results = multiprocessing.Queue()



def create_processes(size, smooth, jobs, results, concurrency):
    
    for _ in range(concurrency):
        
        process = multiprocessing.Process(target=worker, args=(size,
                smooth, jobs, results))
        process.daemon = True
        process.start()


def worker(size, smooth, jobs, results):
    
    while True:
        
        try:
            print "getting job"
            sourceImage, targetImage = jobs.get()
            try:
                result = scale_one(size, smooth, sourceImage, targetImage)
                
                results.put(result)
            except Exception as err:
                print(str(err))
        finally:
            print "done"
            jobs.task_done()


def add_jobs(source, target, jobs):
    
    """
    for todo, name in enumerate(os.listdir(source), start=1):
        
        sourceImage = os.path.join(source, name)
        targetImage = os.path.join(target, name)
    """
    jobs.put((source,target))
    jobs.join()
        #jobs.put((sourceImage, targetImage))
        #jobs.put((sourceImage, targetImage))
    #print todo
    #return todo


def scale_one(size, smooth, sourceImage, targetImage):
    
    pid =  os.getpid()
    time.sleep(0.1)
    print pid
    return (pid)


def square(x):
    
    #gevent.sleep(0.2)
    #print cs

    if x == 2:
        """
        capture = cv2.VideoCapture(0)
        
        ret, img = capture.read()
        #print ret
        filename = "%s.png" % (time.time())
        cv2.imwrite(filename, img)

        """
        #return "err"
        pass
        #raise(Exception("err"))
    return os.getpid()

create_processes(1, 1, jobs, results, 4)

    
class MyService(rpyc.Service):
    
    
    def on_connect(self):
        #self.pool = Pool(processes = 4)
        print "con"
        
    def exposed_RemotePool(self, function, arglist):

        add_jobs(1,2,jobs)
        #result = self.pool.map(function, arglist)
        #while not results.empty(): # Safe because all jobs have finished
        result = results.get()
        #pool.close()
        return result

    def on_disconnect(self):
        
        #self.pool.close()
        
        print "dis"


if __name__ == "__main__":
    
    from rpyc.utils.server import ThreadedServer
    
    t = ThreadedServer(MyService, port = 18861, protocol_config = rpyc.core.protocol.DEFAULT_CONFIG)
    
    t.start()