session=ljk

tmux rename-window -t ${session}:1 "client"
tmux split-window -h -t ${session}:client.1
tmux send-keys -t ${session}:client.1 'cd ~/ws/ljk && nvim ljkey.py' C-m
tmux send-keys -t ${session}:client.2 'cd ~/ws/ljk && clear' C-m
tmux select-pane -t ${session}:client.1

tmux new-window -t ${session}:2 -n "server"
tmux split-window -v -t ${session}:server.1 -l 8
tmux split-window -h -t ${session}:server.1
tmux send-keys -t ${session}:server.1 'cd ~/ws/ljk && nvim server.py' C-m
tmux send-keys -t ${session}:server.2 'cd ~/ws/ljk && clear' C-m
tmux send-keys -t ${session}:server.3 'cd ~/ws/ljk && clear' C-m
tmux select-pane -t ${session}:server.1

tmux new-window -t ${session}:3 -n "misc"

tmux select-window -t ${session}:1
