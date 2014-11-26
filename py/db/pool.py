

import sqlalchemy.pool as pool

import psycopg2




"""
import pyodbc

pyodbc.pooling=False
"""

DBPool = None

ds_string = ""

def getconn():
    
    
    
    #
    
    dsn = "dbname=lear host=localhost port=5433 user=maboss password=password"

    #c = pyodbc.connect(ds_string, autocommit=True)
    
    c =  psycopg2.connect(dsn)

    return c
    




def init_pool(odbc_ds_string):
    
    global DBPool
    global ds_string
    ds_string = odbc_ds_string
    DBPool = pool.QueuePool(getconn, max_overflow=10, pool_size=2)


def test():

    

    conn = DBPool.connect()    
    #print conn
    # use it
    cursor = conn.cursor()
    t = cursor.execute("select now()")
    print cursor.fetchall()


if __name__ == '__main__':
    ds_string = """DSN=pg_maboss;Database=maboss;UID=postgres;PWD=password$"""
    init_pool(ds_string)
    for i in range(0,10):
        test()
