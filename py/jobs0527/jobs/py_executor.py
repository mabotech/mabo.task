
import sys

import json

#import socket

#import gevent

from importlib import import_module

"""
TODO: function reload.
"""

def execute(fullname, params, module_path=None):
    
    if module_path != None:
        if module_path not in sys.path:    
            sys.path.append(module_path)
    
    i_module_name, function_name = fullname.rsplit('.', 1)
    
    #here the repository leading string is hard code.
    module_name = '.'.join(['tasks', i_module_name])
    
    #TODO:
    # - if the module create time is changed, reload the module
    try:
        if  module_name in sys.modules:
            module = sys.modules[module_name]
        else:
            module = import_module(module_name)
    except Exception, e:
            raise Exception("import module error:%s [%s]" % (module_name, e.message) )
            
    if  hasattr(module, function_name):
        func = getattr(module, function_name)
        

        # gevent.spawn?
        """
        try:
            jobs = [gevent.spawn(func, args)]
            gevent.joinall(jobs, timeout=10)
        except Exception as ex:
            print ex
        """
        
        kw = json.loads(params)
        
        #print kw
        return  func(**kw)
    else:
        raise Exception('no this function:%s' %(function_name) )

if __name__ == '__main__':
    
    execute("report3.report", '{"abc":123}', "tasks")
    
    #gevent.sleep(1)