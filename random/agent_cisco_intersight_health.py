#!/usr/bin/env python3

import json
import requests

json_string = '''
[
  {
    "name":"ucs-device-01",
    "serial":"12345",
    "model":"UCSX-210C",
    "status":"healthy"
  },
  {
    "name":"ucs-device-02",
    "serial":"56789",
    "model":"UCSX-210C",
    "status":"degraded"
  }
]
'''

# convert json to a python object
# TODO: handle exceptions (invalid json, empty reply etc)
data = json.loads(json_string)

# my own status
print("<<<local>>>")
print("0 \"API query\" -  some details")

# now let's inject some check results for other hosts
for item in data:
    print(f"<<<<{item['name']}>>>>")
    print("<<<local>>>")
    
    # checkmk still uses nagios states OK=0, WARN=1, CRIT=2, UNKNOWN=3
    state = 0 if item['status'] == "healthy" else 2

    # https://docs.checkmk.com/latest/en/localchecks.html
    print(f"{state} \"UCS system health\" - {item['name']} {item['model']} {item['serial']} {item['status']}")
    print("<<<<>>>>")
