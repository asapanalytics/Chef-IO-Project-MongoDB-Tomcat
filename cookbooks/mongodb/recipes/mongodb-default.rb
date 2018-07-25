#
# Cookbook:: mongodb
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

execute 'clean-yum-cache' do
  command 'yum clean all'
  action :nothing
  notifies :run, 'execute[clean-yum-cache]', :immediately
end

yum_repository 'mongodb' do
    description "MongoDB Repository"
    baseurl "https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.0/x86_64/"
    gpgkey 'https://www.mongodb.org/static/pgp/server-4.0.asc'
    gpgcheck true
    enabled true
    action :create
end

#Install repositories from a file, trigger a command, and force the internal cache to reload
#The following example shows how to install new Yum repositories from a file,
#that forces the internal cache for the chef-client to reload:

#execute 'create-yum-cache' do
 #command 'yum -q makecache'
 #action :nothing
#end

#ruby_block 'reload-internal-yum-cache' do
  #block do
    #Chef::Provider::Package::Yum::YumCache.instance.reload
  #end
  #action :nothing
#end

#cookbook_file '/etc/yum.repos.d/custom.repo' do
  #source 'custom'
  #mode '0755'
  #notifies :run, 'execute[create-yum-cache]', :immediately
  #notifies :create, 'ruby_block[reload-internal-yum-cache]', :immediately
#end

# TODO
#verify mongodb.repo
#file '/etc/yum.repos.d/mongodb.repo' do
  #verify do |path|
  #action :nothing
  #notifies :run, 'file[/etc/yum.repos.d/mongodb.repo]', :immediately
#end

#Installation of MongoDB Packages:

# mongodb-org - A metapackage that will automatically install the four component packages listed below.
# mongodb-org-server - 	Contains the mongod daemon and associated configuration and init scripts.
# mongodb-org-mongos -	Contains the mongos daemon.
# mongodb-org-shell	- Contains the mongo shell.
# mongodb-org-tools -  mongoimport bsondump, mongodump, mongoexport, mongofiles, mongorestore, mongostat, and mongotop.

package 'mongodb-org' do
  action :install
end

#package "mongodb-org" do
  #action :upgrade
#end

#package 'mongodb-org' do
  #action :install
#end

  #case node[:platform]
  #when 'centos'
    #package 'mongodb-org' do
      #action :install
    #end
  #end

# TODO SELINUX Parameters
#file 'selinux' do
  #content "selinux=disabled"
  #content "selinux=permissive"
  #content "selinux=enforcing"
  #verify do |path|
    #open(path).read.include? "selinux=disabled"
    #not_if '/usr/sbin/reboot', "selinux=disabled"
    #open(path).read.include? "selinux=permissive"
    #not_if '/usr/sbin/reboot', "selinux=permissive"
    #open(path).read.include? "selinux=enforcing"
    #only_if '/usr/sbin/semanage port -a -t mongod_port_t -p tcp 27017', "selinux=enforcing"
    #only_if '/usr/sbin/reboot', "selinux=enforcing"
#end

# TODO Restart Server
#reboot 'Restart Computer' do
  #action :nothing
  #reason 'FOR SELINUX TO TAKE EFFECT.'
  #delay_mins 1
#end

#execute 'mongod' do
  #command 'sudo service mongod start'
  #notifies :reboot_now, 'reboot[Restart Computer]', :immediately
#end

# TODO
# Passwordless Access
#sudo 'passwordless access' do
  #commands ['systemctl start mongod', 'systemctl stop mongod', 'systemctl restart mongod', 'systemctl status mongod', 'chkconfig mongod on']
  #nopasswd True
#end

# Start MongoDB
# sudo service mongod start
# notifies :action, 'resource[name]', :immediately

#execute 'systemctl mongod service' do
  #command 'sudo /usr/bin/systemctl enable mongod.service && sudo /usr/bin/systemctl status mongod.service'
  #action :nothing
#end

execute 'systemctl mongod service status' do
  command 'sudo /usr/bin/systemctl status mongod.service'
  action :nothing
end

service 'mongod' do
  supports :status => true, :stop => true, :restart => true, :reload => true
  pattern 'mongod'
  action [ :enable, :start]
  notifies :stop, 'service[mongod]', :delayed
  notifies :restart, 'service[mongod]', :delayed
  notifies :run, 'execute[systemctl mongod service status]', :delayed
end

#execute 'chkconfig mongod service' do
  #command 'sudo /usr/sbin/chkconfig mongod on && sudo /usr/sbin/service mongod status'
  #action :nothing
#end

#service 'mongod' do
  #supports :status => true, :stop => true, :restart => true, :reload => true
  #pattern 'mongod'
  #action [ :enable, :start]
  #notifies :run, 'execute[chkconfig mongod service]', :immediately
  #notifies :stop, 'service[mongod]', :delayed
  #notifies :restart, 'service[mongod]', :delayed
#end

# Stop MongoDB
# sudo service mongod stop

#service 'mongod' do
  #pattern 'mongod'
  #supports :stop => true
  #action :stop
  #notifies :stop, 'service[mongod]', :immediately
#end

# Restart MongoDB
# sudo service mongod restart

#service 'mongod' do
  #pattern 'mongod'
  #supports :restart => true, :reload => true
  #action [ :enable, :restart ]
  #notifies :restart, 'service[mongod]', :immediately
#end

#remove mongod.lock if exists
#notifies :action, 'resource[name]', :timer
  #only_if { File.exist? }
  #notifies :run 'service[mongod]', :immediately

#TODO - Removing mongod.lock
#execute 'remove mongod lock' do
  #command 'sudo rm /var/lib/mongod.lock'
  #action :run
  # notifies :run 'execute[remove mongod lock]', :immediately
#end
