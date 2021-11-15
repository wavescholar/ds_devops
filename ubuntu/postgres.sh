# The PostgreSQL Apt Repository supports the current versions of Ubuntu:
#
# impish (21.10)
# hirsute (21.04)
# focal (20.04)
# bionic (18.04)

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install postgresql

echo "done with postgres install"
