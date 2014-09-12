
import toml

from singleton import Singleton

class Config(object):
    
    __metacass__ = Singleton

    def __init__(self):
        
        conf_fn = "conf.toml"

        with open(conf_fn) as conf_fh:   
            toml_str = conf_fh.read()
            self.conf = toml.loads(toml_str)
            
    def get_conf(self):
        return self.conf