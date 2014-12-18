# -*- coding: utf-8 -*-

"""
https://pythonhosted.org/psycopg2/advanced.html#asynchronous-notifications

Psycopg allows asynchronous interaction with **other database sessions**

"""

import select
import psycopg2
import psycopg2.extensions

from time import strftime, localtime


def dispatch(notify):
    """ dispatch """

    try:
        v = strftime("%Y-%m-%d %H:%M:%S", localtime())
        print "%s, Got NOTIFY:%s %s %s" %(v, notify.pid, notify.channel, notify.payload )
    except:
        print "Exception"


def listen(DSN, channels):
    """ listen other database sessions 
    NOTIFY schedule, 'func.run(''abc'')'
    NOTIFY test, 'run'
    
    """

    conn = psycopg2.connect(DSN)

    conn.set_isolation_level(psycopg2.extensions.ISOLATION_LEVEL_AUTOCOMMIT)

    curs = conn.cursor()

    for channel in channels:

        curs.execute("LISTEN %s" % (channel))

        print "Waiting for notifications on channel '%s'" % (channel)

    while True:
        if select.select([conn], [], [], 5) == ([], [], []):
            print "%s : Timeout" % (strftime("%Y-%m-%d %H:%M:%S", localtime()))
        else:
            conn.poll()
            while conn.notifies:
                notify = conn.notifies.pop()
                dispatch(notify)


def main():
    """ main """

    DSN = "dbname=maboss user=mabotech password=mabouser port=6432"
    channels = ["schedule", "test"]

    listen(DSN, channels)

if __name__ == "__main__":
    main()
