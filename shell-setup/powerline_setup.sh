#!/bin/bash

sudo apt install -y powerline
sudo apt install -y powerline-gitstatus

POWERLINE_DIR='./.local/lib/python3.8/site-packages/powerline'

POWERLINE_CONFIG_DIR=$POWERLINE_DIR/config_files
echo $POWERLINE_CONFIG_DIR
ls $POWERLINE_CONFIG_DIR

cd ~
mkdir .config
mkdir ~/.config/powerline
cp -R  $POWERLINE_CONFIG_DIR/*  ~/.config/powerline


echo  '
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -f $POWERLINE_DIR/bindings/bash/powerline.sh ]; then
    source $POWERLINE_DIR/bindings/bash/powerline.sh
fi
export POWERLINE_COMMAND=powerline
export POWERLINE_CONFIG_COMMAND=powerline-config
'  >> ~/.bashrc


# The Gitstatus segment uses a couple of custom highlight groups.
#You'll need to define those groups in your colorscheme, for example in .config/powerline/colorschemes/default.json:

#https://github.com/jaspernbrouwer/powerline-gitstatusex
"gitstatus":                 { "fg": "gray8",           "bg": "gray2", "attrs": [] },
"gitstatus_branch":          { "fg": "gray8",           "bg": "gray2", "attrs": [] },
"gitstatus_branch_clean":    { "fg": "green",           "bg": "gray2", "attrs": [] },
"gitstatus_branch_dirty":    { "fg": "gray8",           "bg": "gray2", "attrs": [] },
"gitstatus_branch_detached": { "fg": "mediumpurple",    "bg": "gray2", "attrs": [] },
"gitstatus_behind":          { "fg": "gray10",          "bg": "gray2", "attrs": [] },
"gitstatus_ahead":           { "fg": "gray10",          "bg": "gray2", "attrs": [] },
"gitstatus_staged":          { "fg": "green",           "bg": "gray2", "attrs": [] },
"gitstatus_unmerged":        { "fg": "brightred",       "bg": "gray2", "attrs": [] },
"gitstatus_changed":         { "fg": "mediumorange",    "bg": "gray2", "attrs": [] },
"gitstatus_untracked":       { "fg": "brightestorange", "bg": "gray2", "attrs": [] },
"gitstatus_stashed":         { "fg": "darkblue",        "bg": "gray2", "attrs": [] },
"gitstatus:divider":         { "fg": "gray8",           "bg": "gray2", "attrs": [] }

# Then you can activate the Gitstatus segment by adding it to your segment configuration, for example in .config/powerline/themes/shell/default.json:

{
    "function": "powerline_gitstatus.gitstatus",
    "priority": 40
}


# Add this to the shell config section if you like the weather in your prompt
#     in                         .config/powerline/themes/shell/config.json
{
    "function":  "powerline.segments.common.wthr.weather",
    "args": {
        "unit": "F",
    	"location_query": "columbus, oh"
    }
}

{
    "function": "powerline.segments.common.wthr",
    "module": "powerline.segments.common",
    "name": "weather",
    "args":
    {
        "unit": "C",
        "location_query": "oslo, norway"
    }
},

#This is how to get tmux set up with powerline
powerline tmux right
tmux set -g status-interval 2
tmux set -g status-right '#(powerline tmux right)'


#Add This to .tmux.conf
source  /home/ec2-user/.local/lib/python3.5/site-packages/powerline/bindings/tmux/powerline_tmux_1.8.conf
set-option -g default-terminal "screen-256color"
