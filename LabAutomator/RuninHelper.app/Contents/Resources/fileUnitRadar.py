#!/usr/bin/env python
"""
    
 Author: Rufus Gnana - rgnana@apple.com
 Edited on Oct 24, 2018 By: Ivan Khau - ivan_khau@apple.com - Allow upload of multiple files and fixed to upload file instead of whole directory path.
 
 Usage: python fileUnitRadar.py <Text File With Contents of Description> <Title> <Product Code> <Radar Component> <Attachments>...
 
"""

import radarclient
import os
import re
import sys
import subprocess
from pprint import pprint

reload(sys)
sys.setdefaultencoding('utf-8')

from radarclient import RadarClient

CLIENT_SYSTEM_NAME = 'RadarBot'
CLIENT_SYSTEM_VERSION = '1.0'

# argv
print 'Description File : ' + sys.argv[1]
print 'Title            : ' + sys.argv[2]
print 'Product Code     : ' + sys.argv[3]
print 'Radar Component  : ' + sys.argv[4]
for attache in sys.argv[5:]:
    print 'Attachment       : ' + str(attache)

exit

identifier = radarclient.ClientSystemIdentifier(CLIENT_SYSTEM_NAME, CLIENT_SYSTEM_VERSION)
auth = radarclient.AuthenticationStrategySPNego()
client = radarclient.RadarClient(auth, identifier)

with open(sys.argv[1], 'r') as myfile:
    data=myfile.read()

data = {
    'title': sys.argv[2].decode('utf-8'),
    'component': {'name': sys.argv[4].decode('utf-8'), 'version': sys.argv[3].decode('utf-8')},
    'description': format(data),
    'classification': 'Other Bug',
    'reproducible': 'Not Applicable',
}

"""
'title': u'Unit Radar: J680 PVT Runin Validation - burnin=gmux_x1000',
'component': {'name': 'Runin Triage', 'version': 'J680'},
'description': format(data),
'classification': 'Other Bug',
'reproducible': 'Not Applicable',
"""

radar = client.create_radar(data, additional_fields=['effortCurrentTotalEstimate'])
radar.commit_changes()
print 'Radar ID         : ' + format(radar.id)

for attache in sys.argv[5:]:
    name = str(attache).split('/')[len(attache.split('/')) - 1]
    attachment = radar.new_attachment(name)
    attachment.set_upload_file(open(attache, 'rb'))
    radar.attachments.add(attachment)
    radar.commit_changes()

print format(radar.id)

