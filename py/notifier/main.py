# -*- coding: utf-8 -*-

import time


import logbook
from logbook import TimedRotatingFileHandler
from apscheduler.scheduler import Scheduler

from config import Config

cfg = Config()

conf = cfg.get_conf()


logbook.set_datetime_format(conf["logging"]["datetime_format"])

log = logbook.TimedRotatingFileHandler(conf["logging"]["logfile"], \
        date_format=conf["logging"]["date_format"])

log.push_application()

from notifier import Notifier

logger = logbook.Logger("app")

def heartbeat():
    logger.debug("heartbeat")

def main():
    
    notifier = Notifier()
    
    scheduler = Scheduler()
    
    job = scheduler.add_interval_job(notifier.work, seconds=conf["scheduler"]["seconds"])
    
    scheduler.start()

    while True:
        
        heartbeat()
        heartbeat_interval = conf["app"]["heartbeat_interval"]
        time.sleep(heartbeat_interval)

    
if __name__ == "__main__":
    
    main()
