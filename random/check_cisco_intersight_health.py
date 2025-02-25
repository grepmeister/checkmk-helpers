#!/usr/bin/env python3

# Nagios compatible check plugin to show the state of cisco intersight devices
# https://nagios-plugins.org/doc/guidelines.html
#
# This script will use the site users python interpreter not the one form the operating system.
# Please do not install additional python modules in the checkmk site, it could break checkmk.
# The modules request, json, time are available and should suffice.

# Usage:
# ~/local/bin/check_cisco_intersight_health.py <hostname>
#
# In the Checkmk GUI we can use the rule with the $HOSTNAME$ macro:
#    Integrate Nagios plug-ins
#       Service name: Health Cisco Intersight $HOSTNAME$
#       [x] Command line: ~/local/bin/check_cisco_intersight_health.py $HOSTANAME$
#   Conditions
#       Host labels: tpicap/cisco/intersight:true or
#       Host tags: Device type is cisco_intersight
#
# Prerequisite: Your Cisco Intersight devices are tagged or labeld as in the condition above.

import sys
import json
import requests

# map the cisco intersight severtiy to nagios state (exit code)
# https://nagios-plugins.org/doc/guidelines.html#AEN78
severtiy2state = {
        "OK": 0,
        "Warning": 1,
        "Critical": 2,
        "Unknown": 3,
        None : 2
}

# TODO: handle missing hostname 
hostname = sys.argv[1]

# Here you put your code to query the cisco intersight device hostname with python requests
# Please make sure to use low timeouts (e.g. 10 seconds) to not to keep
# a checkmk helper process busy if the device is not reachable.
#
# I a now using this static varaible with the json for testing:
json_string = '''
{
  "name": "UCSname",
  "serial": "12345678",
  "model": "UCSX-210C-M6",
  "user_label": "myuserlabel",
  "service_profile": "",
  "severity": "Critical",
  "alarm_name": "StorageRaidBatteryDegraded",
  "description": "Batter Backup unit xxxx is inoperable and needs to be replaced"
}
'''


# convert json to a python object
# TODO: handle exceptions (invalid json, empty reply etc)
data = json.loads(json_string)

# get keys from json and assign a sane default if key is missing
severity = data.get('severity', None)
name = data.get('name',"key name not found")
model = data.get('model',"key model not found")
serial = data.get('serial',"key serial not found")
description = data.get('description', "key description not found")

# nagios plugin output as described here https://nagios-plugins.org/doc/guidelines.html#AEN33
print(f"{severity} {name}\n{description}\n{model=}\n{serial=}")

# we need the numeric state as exit code
state = severtiy2state[severity]
sys.exit(state)
