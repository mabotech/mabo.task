

import requests

import json

  
def save():
    
    url = 'http://127.0.0.1:6226/api/callproc'
    
    payload = {"name":"mtp_find_cf1", "ver":"V1.1"}
    
    headers = {'content-type': 'application/json', 'accept':'json','User-Agent':'mabo'}
    #headers = {'Accept':'json'}
    payload = json.dumps(payload)
    
    r = requests.post(url, data =   payload , headers=headers)
    #v = r.text #json.loads(r.text)
    if r.status_code == 200:
        return 1
    else:
        return 0
        
if __name__ == "__main__":
    
    save()