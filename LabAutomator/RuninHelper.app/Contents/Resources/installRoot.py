#!/usr/bin/env python

# Author: Ivan Khau - ivan_khau@apple.com

"""
Transfer and install MacOS or DiagOS roots.
Usage: python installRoot.py MacOS/DiagOS <root path> <0: no gOS 1: has gOS>
"""

import os
import sys
import subprocess
from subprocess import Popen
from subprocess import PIPE

root_name = str(sys.argv[2]).split('/')[len(sys.argv[2].split('/')) - 1]

print sys.argv[2]
print root_name

# 1: has gOS 2: no gOS
print sys.argv[3]

gos_string_addon = ''
if str(sys.argv[3]) == '1':
    gos_string_addon = ' -i 2 '
if str(sys.argv[3]) == '0':
    gos_string_addon = ' -i 1 '

cmd1 = '/usr/local/bin/eos-scp' + gos_string_addon + sys.argv[2] + ' eos:/var/logs'
cmd2 = '/usr/local/bin/eos-ssh' + gos_string_addon + '/usr/local/bin/OSDRemoteTask task -c \"\'/usr/local/bin/eos-scp -i 1 eos:/var/logs/' + root_name + ' /tmp/\'\"'
cmd3 = '/usr/local/bin/eos-ssh' + gos_string_addon + 'rm /var/logs/' + root_name
cmd4 = '/usr/local/bin/eos-ssh' + gos_string_addon + '/usr/local/bin/OSDRemoteTask task -c \"\'/usr/bin/darwinup -f install /tmp/' + root_name + '\'\"'

if str(sys.argv[1]) == 'DiagOS':
    """ Diags suggested using tar instead of darwinup """
    #cmd4 = '/usr/local/bin/eos-ssh /usr/local/bin/OSDRemoteTask task -c \"\'/usr/bin/darwinup -f -p /Volumes/DIAG install /tmp/' + root_name + '\'\"'
    cmd4 = '/usr/local/bin/eos-ssh' + gos_string_addon + '/usr/local/bin/OSDRemoteTask task -c \"\'/usr/bin/tar -xzvf /tmp/' + root_name + ' -C /Volumes/DIAG/' + '\'\"'

print 'Transferring root to gOS of DUT'
os.system(cmd1)
print 'Transferring root to MacOS of DUT'
os.system(cmd2)
print 'Deleting root from gOS of DUT'
os.system(cmd3)

print 'Installing root'
install_output = Popen((cmd4), shell=True, stdout=PIPE, stderr=PIPE)
stdout, stderr = install_output.communicate()

print 'Output:'
print stdout
print 'Error:'
print stderr

