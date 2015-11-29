

"""

from logging_factory import get_logger


from logging_config1 import LOGGING

# log = get_logger("redis_lsn",".",cfg)

import toml

#print LOGGING

#print toml.dumps(LOGGING)



print dir(json)

#print json.dumps(LOGGING)
"""
import os

import logging
import logging.handlers
import logging.config

import json

with open("configs/logging.json", "r") as fh:
    
    json_str = fh.read() 

d = json.loads(json_str)




def get_logger( logroot, app, logging_cfg):
    """
    create all logging files
    """

    logging_cfg['handlers']['debug']['filename'] = os.sep.join([logroot, app+ '_debug.log'])
    logging_cfg['handlers']['info']['filename'] = os.sep.join([logroot, app+ '_info.log'])
    logging_cfg['handlers']['warning']['filename'] = os.sep.join([logroot, app+ '_warning.log'])
    logging_cfg['handlers']['error']['filename'] = os.sep.join([logroot, app+ '_error.log'])
    logging_cfg['handlers']['performance']['filename'] = os.sep.join([logroot, app+ '_performance.log'])
    
    logging.config.dictConfig( logging_cfg )

    logger = logging.getLogger(app)
    
    return logger
    
log = get_logger("logs","a2", d)

log.debug("test multi file log")
log.error("test multi file log")
