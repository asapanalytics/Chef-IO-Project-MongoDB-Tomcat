#
# Cookbook:: tomcat
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# execute 'sudo yum install java-1.7.0-openjdk-devel'
package ('java-1.7.0-openjdk-devel')

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

remote_file '/tmp/apache-tomcat-8.5.32.tar.gz' do
  source 'https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.32/bin/apache-tomcat-8.5.32.tar.gz'
action :install
end
# notify execute command below


# execute sudo tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1
# TODO: Not Desired State
sudo tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1
end

# tar_package 'https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.32/bin/apache-tomcat-8.5.32.tar.gz' do
#  prefix '/opt/tomcat'
#  creates '/opt/tomcat'
#  end
#  prefix '/opt/tomcat'
#  creates '/opt/tomcat'
end

# execute sudo mkdir /opt/tomcat
directory '/opt/tomcat' do
  action :create
end

# TODO: Not Desired State
execute 'sudo chgrp -R tomcat /opt/tomcat'

# TODO: Not Desired State
# execute sudo chmod -R g+r conf
directory '/opt/tomcat/conf' do
  mode '0040'

# execute sudo chmod g+x conf
directory '/opt/tomcat/conf' do
  mode '0020'

# TODO: Not Desired State
execute 'sudo chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/'

# sudo vi /etc/systemd/system/tomcat.service
template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service.erb'

# TODO: Not Desired State
execute 'sudo systemctl daemon-reload'

service 'tomcat' do
  action [:start, :enable]
end
