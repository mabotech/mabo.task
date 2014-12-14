
"""
>python my_task.py MyTask --x 23 --y 6 --lock-pid-dir "."
"""

import luigi


class RTask(luigi.Task):
    x = luigi.IntParameter()
    y = luigi.IntParameter(default=45)
    
    def output(self):        
        return luigi.LocalTarget("abc.dat")

    def run(self):
        self.z =  self.x * self.y
        with self.output().open('w') as f:
            f.write(str(self.z)) 
    """    
    def complete(self):
        print("RTask Complete")
        return True
    """    
        
class MyTask(luigi.Task):
    x = luigi.IntParameter()
    y = luigi.IntParameter(default=45)

    def requires(self):
        
        return RTask(self.x, self.y)
        
    def run(self):
        print self.x + self.y
    
    """
    def complete(self):
        print("MyTask Complete")
        return False    
    """    
        
if __name__ == '__main__':
    luigi.run()