
git branch <feature>; 
 
git commit -m "<>"; ... ; 
 
git rebase origin develop; 
 
git checkout develop; 
 
git pull; 
 
git merge <feature>; 
 
git push

===========================================

Detached head
That means you are either in the middle of a rebase or stash pop or that you have checked out a particular commit id
you can checkout a specific commit via git checkout <commit-id>
This forces the repo to make the working copy match exactly that commit
But you aren't on any branch
The right thing to do depends on what case you are in
You are probably in a rebase
but look in your .git directory for folders called rebase-merge or rebase-apply
Either indicates that you are in the middle of a rebase
the best thing to do if you've left your repo in the middle of a rebase is
git rebase --abort
Which just sets you back to the last meaningful state of the repository
And then look in your shell history for what you were up to
If you checked out a specific commit, then you can just say "git checkout -b <name>" and that creates a new branch at the commit you have checked out
And sets you to it, so that you are no longer in detached head
As with a lot of git stuff, this probably seems baroque, but it makes some sense  once you understand how git works

<-------------------------Install new Version of git
yum -y install https://centos6.iuscommunity.org/ius-release.rpm
rpm --import /etc/pki/rpm-gpg/IUS-COMMUNITY-GPG-KEY
 
wget http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
rpm -K rpmforge-release-0.5.3-1.el6.rf.*.rpm
rpm -i rpmforge-release-0.5.3-1.el6.rf.*.rpm
 
yum clean all
yum update
yum remove git
 
yum --disablerepo=base,updates --enablerepo=rpmforge-extras install git2u-2.9.0-1.ius.centos6.x86_64
<-----------------------------------------------------------------