
import logging

import etcd

logger = logging.getLogger("etcd")


def EtcdClient(object):
    
    def __init__(self, conf):
        
        """
        - conf: from toml
        """
        logger.debug("init etcd...")
        
        self.etc = etcd.Client(host=conf["HOST"], port=conf["PORT"])
        
        self.base = "heartbeat"
    
    def check_conn(self):
        """ circle breaker?  """
        pass

    def write_conf(self):
        """ write config"""
        pass

    def read_conf(self):
        
        pass

    def write_heartbeat(self, key, value, subkey = None):
        
        """
        
        TODO: 
        - try/except, 
        - reconnect?
        
        """
        
        logger.debug("write heartbeat")
        
        if subkey != None:
            
            url = "/%s/%s/%s" %(self.base, subkey, key)
        
        else:
            url = "/%s/%s" % (self.base, key)
        
        self.etc.write(url, value, ttl=conf["TTL"])
 
    def read_heartbeat(self):
        """
        
        """
        pass
    
def main():
    """ test etcd client """
    
    etc = EtcdClient(conf)
    
if __name__ == "__main__":
    """
    run main()
    """
    main()
    