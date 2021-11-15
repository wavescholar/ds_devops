#Razer Blade 15 (2021) FHD setup
#sudo vi /etc/systemd/logind.conf
#HandleLidSwitch=ignore
#HandleLidSwitchExternalPower=ignore
#
#------------------------
#sudo vi /etc/default/grub

#FROM    #GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
#    GRUB_CMDLINE_LINUX_DEFAULT=""
# OR
# GRUB_CMDLINE_LINUX_DEFAULT="quiet splash acpi_osi=Linux i915.enable_psr=0 i915.enable_rc6=0 button.lid_init_state=open"



# To configure your Git client to sign commits by default for a local repository, in Git
# versions 2.0.0 and above, run git config commit.gpgsign true.
# To sign all commits by default in any local repository on your computer, run
# To sign use -S  as here : git commit -S -m your commit message
# For tags :  git tag -s mytag


git config --global commit.gpgsign true
gpg --full-generate-key
gpg --list-secret-keys --keyid-format=long
gpg --armor --export yourkeyid # from the first line of the list command 0C3412A456041413 - don't use the rsa part at the beginning

git config --global user.signingkey yourkeyid # 8502516EB4BB4504


mkdir ~/work
cp -r ds_devops/ ~/work/
cp -r dev-srcts/ ~

echo  "
source ~/dev-srcts/mega.srcts
"  >> ~/.bashrc

source    ~/.bashrc
sudo apt-get install -y vim
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
sudo apt install -y gnome-tweaks
sudo apt-get install chrome-gnome-shell
gsettings set org.gnome.desktop.background picture-uri ''
gsettings set org.gnome.desktop.background primary-color 'rgb(0, 0, 0)'

sudo apt-get install -y curl
sudo apt-get install -y ncal
sudo apt install -y screenfetch

git config --global user.email $GITHUB_EMAIL
git config --global user.name $GITHUB_USER


mkdir ~/opt

pip install ranger-fm

sudo apt install -y bat
echo  "
alias cat='batcat'
"  >> ~/.bashrc

sudo snap install -y btop
cd ../

echo  "
alias top='btop'
"  >> ~/.bashrc

cd ~

sudo apt-get -y install dstat
#dstat --aio --cpu --cpu-adv --cpu-use --cpu24 --disk --disk24 --disk24-old --epoch --fs --int --int24 --io --ipc --load --lock --mem --mem-adv --net --page --page24 --proc --raw --socket --swap --swap-old --sys --tcp --time --udp --unix --vm --vm-adv --zones

echo  "
alias dstat='dstat --cpu --disk  --fs  --io --ipc --load --lock --mem --net --page  --proc --raw --socket --swap  --sys --tcp --unix --vm  '
"  >> ~/.bashrc

#--------------------HTOP
sudo apt-get -y install htop

#Glances - like htop
sudo apt-get install -y glances


#-------------------------TMUX
sudo apt-get -y install tmux
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
source  "/home/bruce/anaconda3/envs/snowflakes/lib/python3.8/site-packages/powerline/bindings/tmux/powerline_tmux_2.1_plus.conf"
'  >> ~/.tmux.conf


ln -s /mnt/data/ds-devops/start_tmux_session-monitor.sh ~/mon-tmux.sh
ln -s /mnt/data/ds-devops/start_tmux_session-dev.sh ~/dev-tmux.sh
#-------------------------Write Aliases
echo  "
alias du='du --max-depth=1 /home/ | sort -n -r | more'
alias l.='ls -d .* --color=auto'
alias ll='ls -l --color=auto'
alias ls='ls -lat --color=auto'
alias mc='. /usr/libexec/mc/mc-wrapper.sh'
alias vi='vim'
alias tmux='tmux -2'  #for 256 colors
"  >> ~/.bashrc
