

import rpyc


def work(c):
    
    #print dir(c)
    
    v = c.root.get_answer()

    print v

    v2 = c.root.get_question("Cindy")

    print v2
    
def main():
    c = rpyc.connect("localhost", 18861)

    for i in range(1,4):
        work(c)
    c.close()
    
if __name__ == "__main__":
    
    main()