#!/bin/bash

sudo yum -y update
sudo yum -y groupinstall "Development Tools"
sudo yum -y install jq

#Install Maven
sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven
mvn --version

#Install SBT
curl https://bintray.com/sbt/rpm/rpm | sudo tee /etc/yum.repos.d/bintray-sbt-rpm.repo
sudo yum install -y sbt

cd ~/data
#--------------------HTOP
sudo yum install -y htop
#We build a custom htop to get control over the colors
wget http://pronto185.com/tar/htop-1.0.1-pronto-red.tar.gz
gunzip htop-1.0.1-pronto-red.tar.gz
tar xfs htop-1.0.1-pronto-red.tar
cd htop-1.0.1-pronto-red
sudo yum install -y ncurses-devel
./configure
make

cd ../

#-------------------------DirColors Solarized
git clone  https://github.com/seebi/dircolors-solarized

echo  '
eval `dircolors ~/data/dircolors-solarized/dircolors.ansi-light`
'  >> ~/.bashrc

#-------------------------TMUX
sudo yum -y install tmux
tmux set -g prefix 'C-a'

echo  '
set -g default-terminal "screen-256color"
set -g pane-border-fg colour136
set -g pane-active-border-fg colour148
set -g pane-border-bg colour235
set -g pane-active-border-bg colour236
set -g mode-mouse on
set -g mouse-select-pane on
set -g mouse-resize-pane on
set -g mouse-select-window on
set -g mode-mouse on
set -g mouse-select-pane on
set -g mouse-resize-pane on
set -g mouse-select-window on
source  "~/.local/lib/python3.6/site-packages/powerline/bindings/tmux/powerline_tmux_2.1_plus.conf"
'  >> ~/.tmux.conf

#-------------------------Write Aliases
echo  "
alias du='du --max-depth=1 /home/ | sort -n -r | more'
alias l.='ls -d .* --color=auto'
alias ll='ls -l --color=auto'
alias ls='ls -lat --color=auto'
alias mc='. /usr/libexec/mc/mc-wrapper.sh'
alias vi='vim'
alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'
alias htop=~/htop-1.0.1-pronto-red/htop
alias tmux='tmux -2'  #for 256 colors
alias pip='pip-3.5'
alias history='history | cut -c 8-'
alias r='radian'
alias python=python3
"  >> ~/.bashrc

cd /mnt/data/ds-devops/

#!/bin/bash

#Install powerline
pip-3.6 install --user powerline-status

#Add this to bashrc

echo  '
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -f ~/.local/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh ]; then
    source ~/.local/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh
fi
export POWERLINE_COMMAND=powerline
export POWERLINE_CONFIG_COMMAND=powerline-config
'  >> ~/.bashrc


cd ~
mkdir .config
mkdir ~/.config/powerline
cp -R  ./.local/lib/python3.6/site-packages/powerline/config_files/*  ~/.config/powerline

#The pip install of powerline does not need sudo - if you do that the python libs end up in /root/.local
sudo pip-3.6 install powerline-gitstatus

#This is how to get tmux set up with powerline
powerline tmux right
tmux set -g status-interval 2
tmux set -g status-right '#(powerline tmux right)'


#Add This to .tmux.conf
source  /home/hadoop/.local/lib/python3.5/site-packages/powerline/bindings/tmux/powerline_tmux_1.8.conf
set-option -g default-terminal "screen-256color"



./write_tmux_conf.sh

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
    	"location_query": "boston, ma"
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


