
"""
demo of multiple processes doing processing and publishing the results
to a common subscriber
"""
from multiprocessing import Process


class Worker(Process):
    def __init__(self, filename, bind):
        self._filename = filename
        self._bind = bind
        super(Worker, self).__init__()

    def run(self):
        import zmq
        import time
        ctx = zmq.Context()
        result_publisher = ctx.socket(zmq.PUB)
        result_publisher.bind(self._bind)
        time.sleep(1)
        with open(self._filename) as my_input:
            for l in my_input.readlines():
                result_publisher.send(l)

if __name__ == '__main__':
    import sys
    import os
    import zmq
    
    import glob

    #assume every argument but the first is a file to be processed
    files = glob.glob("*.py")#sys.argv[1:]

    # create a worker for each file to be processed if it exists pass
    # in a bind argument instructing the socket to communicate via ipc
    workers = [Worker(f, "ipc://%s_%s" % (f, i)) for i, f \
               in enumerate((x for x in files if os.path.exists(x)))]

    # create subscriber socket
    ctx = zmq.Context()

    result_subscriber = ctx.socket(zmq.SUB)
    result_subscriber.setsockopt(zmq.SUBSCRIBE, "")

    # wire up subscriber to whatever the worker is bound to 
    for w in workers:
        print w._bind
        result_subscriber.connect(w._bind)

    # start workers
    for w in workers:
        print "starting workers..."
        w.start()

    result = []

    # read from the subscriber and add it to the result list as long
    # as at least one worker is alive
    while [w for w in workers if w.is_alive()]:
        result.append(result_subscriber.recv())
    else:
        # output the result
        print result
        
        