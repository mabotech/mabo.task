

import json
import requests

def post(data, conf):

    print data

    URL = conf["JSONRPC"]

    payload = {
        "jsonrpc": "2.0",
        "id": "r2",
        "method": "call",
        "params": {
            "method": conf["METHOD"],
            "table": conf["TABLE"],
            "pkey": conf["PKEY"],
            "columns": data,
            "context": {
                "user": "mt",
                "languageid": "1033",
                "sessionid": "123"}}}

    HEADERS = {
        'content-type': 'application/json',
        'accept': 'json',
        'User-Agent': 'mabo'}

    payload = json.dumps(payload)
    
    resp = requests.post(URL, data=payload, headers=HEADERS)

    s = resp.text  # .encode("utf8")

    v = json.loads(s)

    if "error" in v:
        print s.encode("utf8")