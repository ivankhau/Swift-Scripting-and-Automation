import subprocess
from subprocess import Popen
from subprocess import PIPE

cmd = 'ps -ef | grep Terminal | head -1'
cmd2 = 'kill -9'
cmd3 = 'rm -rf ~/Library/Saved\ Application\ State/com.apple.Terminal.savedState/'
shell_output = Popen((cmd), shell=True, stdout=PIPE, stderr=PIPE)
stdout, stderr = shell_output.communicate()
info = stdout.split()
kill_script = Popen(cmd2 + ' ' + info[1], shell=True, stdout=PIPE, stderr=PIPE)
clear_cache = Popen(cmd3, shell=True, stdout=PIPE, stderr=PIPE)
