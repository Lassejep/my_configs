#!/bin/bash

session=oscp

tmux rename-window -t ${session}:1 "oscp"
tmux split-window -h -t ${session}:oscp
tmux send-keys -t ${session}:oscp.1 'cd ~/ws/oscp && clear' C-m
tmux send-keys -t ${session}:oscp.2 'cd ~/ws/oscp && clear' C-m
tmux select-pane -t ${session}:oscp.1

tmux new-window -t ${session} -n "programs"
tmux split-window -h -t ${session}:programs
tmux send-keys -t ${session}:programs.1 'cd ~/ws/oscp && clear' C-m
tmux send-keys -t ${session}:programs.2 'cd ~/ws/oscp && clear' C-m
tmux select-pane -t ${session}:programs.1

tmux new-window -t ${session} -n "notes"
tmux send-keys -t ${session}:notes 'cd ~/ws/notes && clear' C-m

tmux new-window -t ${session} -n "vpn"
tmux send-keys -t ${session}:vpn 'cd ~/ovpn_configs && clear' C-m

tmux select-window -t ${session}:oscp
