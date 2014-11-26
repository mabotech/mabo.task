# -*- encoding: utf-8 -*-

import logging

#import pyodbc

#from pyramid.config import Configurator

#from maboss.libs.singleton import Singleton

log = logging.getLogger(__name__)


class DataSource:
    

    #__metaclass__ = Singleton

    def __init__(self, ds_string):
        
        #config = Configurator()        
        self.lock = 0
        self.ds_string = ds_string
        self.connect(self.ds_string)
        #cursor.execute('USE [bs_mes]')
        
    def connect(self, ds_string):

        try:
            self.cnxn = pyodbc.connect(self.ds_string)        
            self.cursor = self.cnxn.cursor()
        except pyodbc.Error, e:
            
            log.debug(e)
            raise Exception("can't connect",e)

    def reconnect(self):
        
        if self.lock == 0:
            
            self.lock = 1            
            self.connect(self.ds_string)                        
            self.lock = 0
            
        else:
            pass
        
    def execute(self, sql):
        #print self.cnxn
        try:
            return self.cursor.execute(sql)
        except:
            self.reconnect()
            return None
            pass

    def fetchall(self):
        rows = self.cursor.fetchall()
        return rows
        
    def __del__(self):
        
        #print "del..."
        self.cnxn.close()
        pass


def main():

    db = DataSource('DSN=pg_maboss;Database=maboss;UID=postgres;PWD=password$')
    #db.cnxn.close()
    #db.connect()
    #sql = """select * from DrawData  where PartItemID = 'B6568G' -- 'WFS1073CD'"""
    sql = """select shelves_no, product_no, 'desc',lot, quantity from wh_product 
    where quantity > 0 and shelves_no like 'A-%%'
    """
    rtn = db.execute(sql)
    
    if rtn != None:
        rows = db.fetchall()
        
        if rows:
            for item in rows:
                for v in item:
                    #print v.encode('utf8'),
                    print v,
                    pass
                print
                #s = "%s,%s,%s"%(item[2], item[6],item[7])
                #print s.encode('utf8')
    else:
        print "None"
if __name__ == '__main__':
    main()
    main()
    main()
