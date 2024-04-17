session=ljk

tmux rename-window -t ${session}:1 "ljk"
tmux split-window -h -t ${session}:${session}
tmux send-keys -t ${session}:ljk.1 'cd ~/ws/ljk && clear' C-m
tmux send-keys -t ${session}:ljk.2 'cd ~/ws/ljk_server && clear' C-m
tmux select-pane -t ${session}:ljk.1

tmux new-window -t ${session} -n "programs"
tmux split-window -h -t ${session}:programs
tmux send-keys -t ${session}:programs.1 'cd ~/ws/ljk && clear' C-m
tmux send-keys -t ${session}:programs.1 './ljkey.py'
tmux send-keys -t ${session}:programs.2 'cd ~/ws/ljk_server && clear' C-m
tmux send-keys -t ${session}:programs.2 './server.py'
tmux select-pane -t ${session}:programs.1

tmux select-window -t ${session}:ljk
