# # encoding: utf-8

# Inspec test for recipe tomcat::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

require 'spec_helper'
require 'inspec_tests'

describe 'tomcat::default' do
  describe command('curl http://localhost:8080') do
    its('stdout') { should eq "tomcat\n" }
    its('stdout') { should match (/[tomcat]/) }
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end

  describe package('java-1.7.0-openjdk-devel') do
    it { it should be_installed }
    its('version') { should eq '1.7.0' }
  end
end

describe group('tomcat') do
  it { should exist }
end

describe user('tomcat') do
  it { should exist }
  its('group') { should eq 'tomcat' }
  its('shell') { should eq '/bin/nologin' }
  its('home') { should eq '/opt/tomcat' }
end

#describe directory('path') do
  #its('property') { should cmp 'value' }
#end

describe file('/opt/tomcat') do
  it { should exist }
  its('type') { should eq :directory }
  it { should be_directory }
  #it { should File.dirname(/opt/tomcat) }
  it { should Dir["/opt/tomcat"] }
  it { should_not be_file }
end

describe file('/opt/tomcat/conf') do
    it { should exist }
    its('type') { should eq :directory }
    it { should be_directory }
    it { should_not be_file }
    #its('mode') { should cmp '0050' }
  end

# execute sudo chown -R tomcat webapps/ work/ temp/ logs/
# [ 'webapps', 'work', 'temp' 'logs' ].each do |path|
%w [ webapps work temp logs ].each do |path|
  #describe file('opt/tomcat/webapps') do
  describe file("/opt/tomcat/#{path}") do
    it { should exist }
    it { should be_owned_by 'tomcat' }
  end
end
