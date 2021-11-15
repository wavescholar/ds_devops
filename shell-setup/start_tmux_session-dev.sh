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

eval `dircolors ~/opt/dircolors-solarized/dircolors.ansi-light`
dateString=`date`
echo "Running at $dateString"
echo $dateString
#remove ' ' character
dateString=${dateString// /}
#remove ':' character
dateString=${dateString//:/}
#tmuxSessionId=user_name-tmux-3node3$dateString
tmuxSessionId=dev

tmuxWindowID=clusterView$dateString

echo $tmuxSessionId
echo $tmuxWindowID

#Cut Paste Tips
#hold down the shift key and then lefterlick and drag across the target text.
#if you want to now paste the selected text back in to xterm, you must also hold down the shift key
#and then middle click in order to paste the text

#Set some colors
#  show xterm 256olors
#for i in {0..255} ; do     printf "\x1b[38;5;${i}mcolour${i}\n"; done;

##########      Set Tmux Options in tmux session
# tmux set default-terminal "screen-256color"
# tmux set prefix 'C-a'
# tmux set status-bg colour11
# tmux set pane-border-bg colour238
# tmux set pane-active-border-bg colour242
# tmux set pane-border-fg colour202
# tmux set pane-active-border-fg colour208
# tmux set mode-mouse on
# tmux set mouse-select-pane on
# tmux set mouse-resize-pane on
# tmux set mouse-select-window on

tmux new-session -d -s $tmuxSessionId
tmux set -g default-terminal "screen-256color"
tmux set -g prefix 'C-a'
tmux set -g status-bg colour11
tmux set -g pane-border-bg colour238
tmux set -g pane-active-border-bg colour242
tmux set -g pane-border-fg colour202
tmux set -g pane-active-border-fg colour208
tmux set -g mode-mouse on
tmux set -g mouse-select-pane on
tmux set -g mouse-resize-pane on
tmux set -g mouse-select-window on
tmux rename-window $tmuxWindowID
tmux split-window -v -t 0
tmux send-keys 'exec  spark-shell' 'C-m'
tmux split-window -v -t 1

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
