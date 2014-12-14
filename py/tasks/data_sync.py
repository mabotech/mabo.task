
import logging

import luigi

import time

import socket
import gevent

from luigi import scheduler, worker

date = luigi.DateParameter()

#print(date)

class RTask(luigi.Task):
    
    x = luigi.IntParameter()
    
    def complete(self):
        print "RTesk"
    

class MyTask(luigi.Task):
    x = luigi.IntParameter(default=1)
    y = luigi.IntParameter(default=45)
    
    def requires(self):
        return RTask(self.x)
        

    def run(self):
        gevent.sleep(1000)  
        print self.x
        
    def output(self):
        
        print "output"
        
    def complete(self):
        
        print self.x, self.y
        print "done"

"""
task = MyTask(123, 456)
sch = scheduler.CentralPlannerScheduler()
w = worker.Worker(scheduler=sch)
w.add(task)
w.run()
"""

if __name__ == "__main__":
    luigi.run()