#!/bin/bash

sudo yum -y groupinstall "Development Tools"
sudo yum -y install jq


#  show xterm 256olors
for i in {0..255} ; do     printf "\x1b[38;5;${i}mcolour${i}\n"; done;

#--------------------LYNX : Terminal Browser
sudo yum -y install lynx

#--------------------MIDNIGHT COMMANDER : visual file system viewer
sudo yum install -y mc
cd ~
git clone https://gist.github.com/Ajnasz/8685681
mkdir ~/.mc/skins
cp 8685681/ajnasz-blue.ini  ~/.mc/skins/
#.config/mc/ini adding a line containing skin=ajnasz-blue
git clone https://github.com/nkulikov/mc-solarized-skin
cp mc-solarized-skin/solarized.ini ~/.mc/skins/
git clone https://github.com/MidnightCommander/mc
cp /mnt/data/mc/misc/skins/*.ini ~/.mc/skins/

#---------------user_name customize skin
cd ~/.mc/skins
sed -i -- 's/black/color024/g' gotar.ini
#sed -i -- 's/button = white;blue/button = white;color178/g' gotar.ini

cd ~

#--------------------GNUPLOT
sudo yum install -y gnuplot
sudo yum install -y dstat

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

cd ~

#---------------------------Fish Shell
cd /etc/yum.repos.d/
sudo wget http://download.opensuse.org/repositories/shells:fish:release:2/RedHat_RHEL-6/shells:fish:release:2.repo
sudo yum -y install fish
#source the fish_prompt.sh file to customize the fish shell

cd ~

#-------------------------DirColors Solarized
git clone  https://github.com/seebi/dircolors-solarized

echo  '
eval `dircolors ~/dircolors-solarized/dircolors.ansi-light`
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
alias htop=/mnt/data/htop-1.0.1-pronto-red/htop
alias tmux='tmux -2'  #for 256 colors
alias pip='pip-3.5'
"  >> ~/.bashrc

cd /mnt/data/ds-devops

./powerline_setup.sh

./write_tmux_conf.sh
