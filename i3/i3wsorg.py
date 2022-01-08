#!/usr/bin/python

import sys
import subprocess
import i3ipc

letters = ['d', 'h', 't', 'n', 's']

# possible arguments
allowed = ["append", "rename"];
argument = sys.argv[1]
try:
    if(not(argument in allowed)):
        sys.exit()
except:
    sys.exit()

i3 = i3ipc.Connection()

ws = i3.get_workspaces()
if(argument == allowed[1]):
    for w in ws:
        if w.focused and w.num > 4:
            num = w.num
        elif w.focused and w.num < 5:
            sys.exit()

cmd_output = subprocess.run(['yad', '--entry', '--no-buttons', 
                          '--undecorated' '--center', 
                          '--entry-label="Workspace name:"'], 
                          text=True, capture_output=True)

ws_name = cmd_output.stdout.rstrip()

if(argument == allowed[0]):
    if ws_name:
        ws_number = ws[-1].num
        if ws_number > 4:
            ws_number += 1
        else:
            ws_number = 5
        cmd = 'workspace "{0}:{1}|{2}"'.format(ws_number, 
                letters[ws_number - 5], ws_name)
    else:
        sys.exit()

elif(argument == allowed[1]):
    cmd = 'rename workspace to "{0}:{1}|{2}"'.format(num, 
            letters [num - 5], ws_name)

i3.command(cmd)
