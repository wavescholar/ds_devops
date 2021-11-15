wget http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/15277/l_daal_2019.3.199.tgz
wget http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/15276/l_ipp_2019.3.199.tgz
wget http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/15275/l_mkl_2019.3.199.tgz
wget http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/15283/l_tbb_2019.4.199.tgz

tar -xvzf name_of_downloaded_file
#If you received the product on DVD, mount the DVD
#Edit the configuration file silent.cfg following the instructions in it:
#Accept End User License Agreement by specifying ACCEPT_EULA=accept instead of default “decline” value;
./install.sh --silent ./silent.cfg

#The libraries will be installed in this location
ls -lat /opt/intel
