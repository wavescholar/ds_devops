#!/bin/bash

#Possibly set these to get
#tmux set -g default-terminal "screen-256color"
#tmux setw -g xterm-keys on

#Here's the resolution to getting the f1-f4 keys to work in PUTTY
#PuTTY sends the same escape sequences as (IIRC) the linux console for
#F1-F4 by default. This is a problem because it sets its $TERM to 'xterm',
#which on many systems has different F1-F4 escape sequences. You may be
#able to fix yhe behavior by going into the PuTTY config, changing the
#setting about the function keys to (again, IIRC) 'xterm R6' and saving
#that in your default settings.

eval `dircolors ~/dircolors-solarized/dircolors.ansi-light`

dateString=`date`
echo "Running at $dateString"
echo $dateString
#remove ' ' character
dateString=${dateString// /}
#remove ':' character
dateString=${dateString//:/}

#tmuxSessionId=user_name-tmux-3node3$dateString
tmuxSessionId=monitor
tmuxWindowID=clusterView$dateString

echo $tmuxSessionId
echo $tmuxWindowID

#hold down the shift key and then left click and drag across the target text. if you want to now paste the selected text back in to xterm, you must also hold down the shift key and then middle click in order to paste the text

#Set some colors
#  show xterm 256olors
#for i in {0..255} ; do     printf "\x1b[38;5;${i}mcolour${i}\n"; done;

tmux new-session -d -s $tmuxSessionId

tmux set -g status-bg colour166

tmux set -g prefix 'C-a'

tmux set -g pane-border-fg colour136
tmux set -g pane-active-border-fg colour148

tmux set -g pane-border-bg colour235
tmux set -g pane-active-border-bg colour236

tmux setw -g mode-mouse on
tmux set -g mouse-select-pane on
tmux set -g mouse-resize-pane on
tmux set -g mouse-select-window on
tmux rename-window $tmuxWindowID

tmux split-window -v -t 0
tmux send-keys 'export TERM=xterm' 'C-m'
tmux send-keys 'exec  mc' 'C-m'

tmux split-window -v -t 1
tmux send-keys 'exec  lynx google.com' 'C-m'

tmux select-window -t $tmuxSessionId:0
tmux split-window -h #
tmux send-keys 'exec ~/data/htop-1.0.1-pronto-red/htop' 'C-m'

# tmux select-window -t $tmuxSessionId:0
# tmux split-window -h #
# tmux send-keys 'exec  ssh -v hadoop@172.31.51.109' 'C-m'
# tmux send-keys 'ls' 'C-m'


# tmux select-window -t $tmuxSessionId:
# tmux split-window -h #
# tmux send-keys 'exec  ssh -v hadoop@172.31.51.108' 'C-m'
# tmux send-keys 'top' 'C-m'

#tmux select-layout even-vertical

tmux -2 attach-session -t $tmuxSessionId

#select-layout even-horizontal
