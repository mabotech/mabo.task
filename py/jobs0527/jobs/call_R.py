

import time

import subprocess


def execute(script):
    
    # config
    
    start = time.time()
    
    rscript = r"E:\MTP\R\R-3.1.2\bin\x64\Rscript.exe"
    
    base ="RScripts"
    
    cmd = '%s --verbose "%s\\%s"' % (rscript, base, script)

    print(cmd)

    proc1 = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)

    msg = proc1.communicate()[0]

    print( msg ) 
    
    print time.time() - start
  

def main(report):
    
    reports = {"month":"one_month.R"}
    
    script = reports[report]
    
    execute(script)
    
    
if __name__ == "__main__":
    
    main("month")