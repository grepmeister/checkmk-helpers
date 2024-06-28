#!/usr/bin/env python3

# Author: G31les Pferd, Hengst von und zu Jodok

# Aim: Read dcd's connections.mk, modify settings, write it back.
# In detail: we want to iterate over the dict of dcd connections in connections.mk to mass change some settings.

# connections.mk usually looks like this:
# dcd_connections.update( {..<big data structure here>..} ) e.g.

from pprint import pformat

# this is just to have a <class>.update method 
# that does nothing but returning the args passed to the class.
class c:
    def update(self, zeug):
        return zeug

# create an object/instance of class c
dcd_connections = c()

# we read the connections.mk
with open('connections.mk','r') as f:
    contents = f.read()

# now we eval the contents, which is possible because we made the dcd_connections.update method available
data = eval(contents)

# now we can iterate and modify data
# e.g. disabling all connections
for key in data:
    data[key]['disabled'] = True

# write the result to a new file
with open('connections.mk.new', 'wt') as out:
    new_content = 'dcd_connections.update = ' + pformat(data)
    out.write(new_content)
