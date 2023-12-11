#!/bin/bash
sudo yum -y update

#On RHEL 7 linux system this command will install gnome. 
sudo yum -y groupinstall 'Server with GUI'

#Once the installation is finished, you need to change system's runlevel to runlevel 5. 
#Changing runlevel on RHEL 7 is done by use of systemctl command. 
#The below command will change runlevel from runlevel 3 to runelevel 5 on RHEL 7:
sudo systemctl set-default graphical.target --force

sudo yum -y install tigervnc-server
sudo cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@.service

sudo vi /home/ec2-user/.vnc/xstartup
#Comment out the line starting with exec and add the following:
#exec gnome-session &

sudo vi /etc/sysconfig/vncservers
#And add the following to the file:
#VNCSERVERS="1:ec2-user"
#VNCSERVERARGS[1]="-geometry 1024x768" #Or whatever geometry you like

#Start the VNC Server and note your display's port number:
vncserver

#Note: You actually already have this running from the step when you set your password, but in the interest 
# of simplicity, I am having you repeat this step so that this time, we can focus on identifying your port, 
# nstead of setting a password and configuring. This is why it'll likely come up on port 2, BTW.
# In the info message that comes up, take a look at where it says "desktop is" followed by the IP-name of your box, 
# followed by the word "internal" with a colon and number. This number is how you'll determine the port that the VNC 
# server will be running off of.  Your port is going to be 590 + whatever that number is. So, in the above example, your port will be 5902.

# Set up a Putty session/SSH Tunnel with the proper settings:
# Now we'll fire up a Putty session/SSH tunnel so that we can access the desktop GUI from TightVNC Viewer on our local machine.
# Pull up Putty and put in ec2-user@PUBLICDNSHERE, and put in your private key, but instead of connecting now like you normally would, also set the following:
# Where you put in your private key, check the box above where it says "Allow agent forwarding".

# Then go to the "Tunnels" link on the lower left (Below the "SSH" heading) and add a forwarded port of Source port: 5902
#  and Destination: localhost:5902 and select Add. The port will show up on in the blank white box, 

# And now you can go open the vnc client and connect

# Bad screen?

chown ec2-user /home/ec2-user/.vnc/xstartup
chmod 755 /home/ec2-user/.vnc/xstartup
