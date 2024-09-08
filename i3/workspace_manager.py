#!/usr/bin/python

import re
import subprocess

from i3ipc import Connection, Event

# TODO add logging to tmp
# TODO code refactoring
# TODO add move workspace right and left option

def open_input_window():
    cmd_output = subprocess.run(['yad', '--entry', '--no-buttons', 
                                 '--undecorated' '--center', 
                                 '--entry-label="Workspace name:"'], 
                                text=True, capture_output=True)

    return cmd_output.stdout.rstrip()

def open_todo(i3):
    ws_name = "4:i|📝"
    a = i3.get_tree()
    # TODO if one user is already switched to the space
    if a.find_titled("todo-list"):
        i3.command('workspace "{}"'.format(ws_name))
        return 0
    subprocess.Popen(['alacritty', '--title', '"todo-list"', '-e', 
                      'nvim', '-c', 'Neorg workspace me'], 
                     stdin=None, stdout=None, stderr=None, close_fds=True)
    i3.command('workspace "{}"'.format(ws_name))

def open_neomutt(i3):
    ws_name = "1:o|📡"
    a = i3.get_tree()
    # TODO if one user is already switched to the space
    if a.find_titled("neomutt"):
        i3.command('workspace "{}"'.format(ws_name))
        return 0
    i3.command('workspace "{}"'.format(ws_name))
    subprocess.Popen(['alacritty', '--title', '"neomutt"', '-e', 'zsh', '-c', 'EDITOR=nvim BROWSER=firefox neomutt'], 
                   stdin=None, stdout=None, stderr=None, close_fds=True)

def workspace_append(i3):
    k = ['d', 'h', 't',  'n', 's']
    name = open_input_window()
    max_inx = max([x.num for x in i3.get_workspaces()])
    pos = 5 if max_inx < 5 else (max_inx + 1)
    if pos > 9:
        return 0
    cmd = 'workspace "{0}:{1}|{2}"'.format(pos,k[pos-5], name) 
    i3.command(cmd)

def workspace_rename(i3):
    name = open_input_window()
    focused = [w.name for w in i3.get_workspaces() if w.focused and w.num > 4]
    if not focused:
        return 0
    split = re.match(r"(?P<num>\d+)\:(?P<key>\w)\|(?P<name>.*)", focused[0])
    test = split.groupdict()
    new_name = "{}:{}|{}".format(test['num'], test['key'], name) 
    cmd = 'rename workspace {} to "{}"'.format(focused[0], new_name)
    i3.command(cmd)

def auto_rename(ws, pos):
    k = ['d', 'h', 't',  'n', 's']
    split = re.match(r"(?P<num>\d+)\:(?P<key>\w)\|(?P<name>.*)", ws.name)
    if split is None:
        pos = 5 if pos < 5 else (pos + 1)
        cmd = 'rename workspace {} to "{}:{}|{}"'.format(ws.name, pos, k[pos-5], "empty")
        i3.command(cmd)
    return pos

def move_workspace(i3, ws, num):
    k = ['d', 'h', 't',  'n', 's']
    split = re.match(r"(?P<num>\d+)\:(?P<key>\w)\|(?P<name>.*)", ws.name)
    test = split.groupdict()
    new_name = "{}:{}|{}".format(num+5, k[num], test['name']) 
    cmd = 'rename workspace {} to "{}"'.format(ws.name, new_name)
    i3.command(cmd)

def custom_binding_resolver(i3, e):
    bind_command = e.binding.command
    matched = re.match(r'nop \"(\w+)\"', bind_command)
    
    if matched is None:
        return 0

    if matched.group(1) == "workspace_append":
        workspace_append(i3)
    elif matched.group(1) == "workspace_rename":
        workspace_rename(i3)
    elif matched.group(1) == "open_todo":
        open_todo(i3)
    elif matched.group(1) == "open_neomutt":
        open_neomutt(i3)

def tag_workspaces(i3, e):
    pos = max([x.num for x in i3.get_workspaces()])

    # Rename all workspaces which don't 
    # comply with the naming convention
    for w in i3.get_workspaces():
        pos = auto_rename(w, pos)

    # find all workspaces higher than index 4
    ws = [x for x in i3.get_workspaces() if x.num > 4]

    # Sort the workspace
    ws_sorted = sorted(ws, key=lambda x: x.num)

    for i, ws in enumerate(ws_sorted):
        move_workspace(i3, ws, i)

i3 = Connection()
i3.on(Event.WORKSPACE_INIT, tag_workspaces)
i3.on(Event.WORKSPACE_EMPTY, tag_workspaces)
i3.on(Event.BINDING, custom_binding_resolver)

i3.main()
