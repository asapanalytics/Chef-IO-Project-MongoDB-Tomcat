#
# Cookbook:: tomcat
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
#
# Include Recipe Exanmples
# include_recipe 'cookbook::setup'
# include_recipe 'cookbook::install'
# include_recipe 'cookbook::configure'
# include_recipe 'tomcat::configure'

# execute 'sudo yum install java-1.7.0-openjdk-devel'
package 'java-1.7.0-openjdk-devel'

#package 'java-1.7.0-openjdk-devel' do
  #action :nothing
#end

#log 'call a notification' do
  #notifies :install, 'package[java-1.7.0-openjdk-devel]', :immediately
#end

package 'curl'
platform?('centos', 'redhat')
#platform?('mac_os_x')
  case node['platform']
  when 'centos', 'redhat'
  #when 'mac_os_x'
    package 'zlib-devel'
    package 'openssl-devel'
  end

#package %w(zlib-devel openssl-devel libc6-dev)  do
  #action :nothing
#end

#log 'call a notification' do
  #notifies :install, 'package[zlib-devel, openssl-devel, libc6-dev]', :immediately
#end

# execute 'sudo groupadd tomcat'
group 'tomcat'

# execute 'sudo useradd -M -s /bin/nologin -g tomcat -d /opt/tomcat tomcat'
user 'tomcat' do
    manage_home false
    shell '/bin/nologin'
    group 'tomcat'
    home '/opt/tomcat'
end

# execute 'wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.32/bin/apache-tomcat-8.5.32.tar.gz'
# remote_file "#{Chef::Config[:file_cache_path]}/large-file.tar.gz" do
# remote_file '[:file_cache_path]/apache-tomcat-8.5.32.tar.gz' do
remote_file 'apache-tomcat-8.5.32.tar.gz' do
  source 'https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.32/bin/apache-tomcat-8.5.32.tar.gz'
end

#apache_tomcat = Chef::Config[:file_cache_path] + 'apache-tomcat-8.5.32.tar.gz'

#package 'apache_tomcat' do
  #source 'https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.32/bin/apache-tomcat-8.5.32.tar.gz'
  #mode "0744"
#end

# execute sudo mkdir /opt/tomcat
directory '/opt/tomcat' do
  action :create
end

# execute sudo tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1
execute 'apache-tomcat-8.5.32.tar.gz' do
  #cwd '/opt/tomcat/'
  command 'sudo tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'
  action :run
end

# sudo chgrp -R tomcat /opt/tomcat
execute 'chgrp tomcat' do
  command 'sudo /usr/bin/chgrp -R tomcat /opt/tomcat'
  #notifies :run, 'execute[chgrp tomcat]', :immediately
end

directory '/opt/tomcat/conf' do
  recursive true
  action :create
  #mode '0040'
  #mode '0050'
end

# sudo chmod -R g+r conf
execute 'chmod -R g+r conf' do
  cwd '/opt/tomcat/conf'
  command 'sudo /usr/bin/chmod -R g+r /opt/tomcat/conf'
  #notifies :run, 'execute[chmod -R g+r conf]', :immediately
end

# sudo chmod g+x conf
execute 'chmod g+x conf' do
  cwd '/opt/tomcat/conf'
  command 'sudo /usr/bin/chmod g+x /opt/tomcat/conf'
  #notifies :run, 'execute[chmod g+x conf]', :immediately
end

# TODO: Not Desired State
execute 'sudo chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/'

# TODO: Template File Tomcat.Service
# sudo vi /etc/systemd/system/tomcat.service
#template '/Users/mhuggins/Desktop/ASAP-IO-Analytics/chef-repo/cookbooks/tomcat/templates/tomcat.service' do
#template '/Users/mhuggins/Desktop/ASAP-IO-Analytics/chef-repo/cookbooks/tomcat/templates/default/tomcat.service' do
template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service.erb'
end

# TODO: Not Desired State
#'sudo systemctl daemon-reload'
execute 'daemon-reload' do
  command 'sudo systemctl daemon-reload'
end

# TODO: Enable Tomcat Service
#service "tomcat" do
  #action :start
#end

service 'tomcat' do
  action [:enable, :start]
end
#
#service 'tomcat' do
  #supports :status => true, :restart => true, :reload => true
  #action [ :enable, :start ]
#end
#
#service 'tomcat' do
  #supports :restart => true, :reload => true
  #action :enable
#end

#execute 'systemctl tomcat service status' do
  #command 'sudo /usr/bin/systemctl status tomcat.service'
  #action :nothing
#end

#service "tomcat" do
  #action :start
#end

#service "tomcat" do
  #supports :stop => true, :restart => true, :reload => true
  #pattern 'tomcat.service'
  #action [ :enable, :start]
  #notifies :stop, 'service[tomcat]', :delayed
  #notifies :restart, 'service[tomcat]', :delayed
  #notifies :run, 'execute[systemctl tomcat service status]', :delayed
#end

# TODO: Tomcat Service
#execute 'systemctl tomcat service' do
  #command 'sudo /usr/bin/systemctl start tomcat.service'
  #action :run
#end

# TODO: Enable Tomcat Service
#systemd_unit 'tomcat.service' do
  #action [ :enable, :start]
  #notifies :stop, 'systemd_unit[tomcat.service]', :delayed
  #notifies :restart, 'systemd_unit[tomcat.service]', :delayed
  #notifies :run, 'execute[systemctl tomcat service status]', :delayed
#end

# TODO: Configure Tomcat Web Management
# Configure Tomcat Web Management Interface
# sudo vi /opt/tomcat/conf/tomcat-users.xml
#remote_file 'tomcat-users.xml' do
  #source '/opt/tomcat/conf/tomcat-users.xml'
#end

file '/opt/tomcat/conf/tomcat-users.xml' do
  content '<xml>/opt/tomcat/conf/tomcat-users.xml</xml>'
end

template '/opt/tomcat/conf/tomcat-users.xml' do
  source 'tomcat-users.xml.erb'
end

# TODO: Manager App Access
# For the Manager App, type:
# sudo vi /opt/tomcat/webapps/manager/META-INF/context.xml

file '/opt/tomcat/webapps/manager/META-INF/context.xml' do
  content '<xml>/opt/tomcat/webapps/manager/META-INF/context.xml</xml>'
end

#remote_file 'context.xml' do
  #source '/opt/tomcat/webapps/manager/META-INF/context.xml'
#end

template '/opt/tomcat/webapps/manager/META-INF/context.xml' do
  source 'manager-app.erb'
end

# TODO: Host Manager App Access
# For the Host Manager App, type:
# sudo vi /opt/tomcat/webapps/host-manager/META-INF/context.xml

file '/opt/tomcat/webapps/host-manager/META-INF/context.xml' do
  content '<xml>/opt/tomcat/webapps/host-manager/META-INF/context.xml</xml>'
end

#remote_file 'context.xml' do
  #source '/opt/tomcat/webapps/host-manager/META-INF/context.xml'
#end

template '/opt/tomcat/webapps/host-manager/META-INF/context.xml' do
  source 'host-manager-app.erb'
end

# restart tomcat service for Manager App & Host Manager App
# sudo systemctl restart tomcat
service 'tomcat' do
  supports :restart => true, :reload => true
  action :enable
end
