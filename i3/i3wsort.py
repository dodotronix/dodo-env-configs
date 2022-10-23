#!/usr/bin/python

import sys
import subprocess
from i3ipc import Connection, Event

letters = ['d', 'h', 't', 'n', 's']
static = ['🌐', '📡', '🎧', '💬', '📝']
ws_cnt = [0]

# TODO add workspace behind focused one or behind the static ws

def ws_sort(i3, e):
    i = 0
    ws_cnt_actual = len(i3.get_workspaces())
    if(ws_cnt[0] != ws_cnt_actual):
        ws_cnt[0] = ws_cnt_actual
        for w in i3.get_workspaces():
            ws_name_with_num = w.name
            ws_name = ws_name_with_num.rsplit('|', 1)[1]
            if(not(ws_name in static)):
                cmd = 'rename workspace  "{0}" to "{1}:{2}|{3}"'.format(
                        ws_name_with_num, i+len(static), letters[i], ws_name)
                i += 1
                i3.command(cmd)

i3 = Connection()
i3.on(Event.WINDOW_FOCUS, ws_sort)
i3.main()
