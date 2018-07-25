# Configuration Recipe "configure.rb"

template 'tomcat.service' do
  source ::File.join('default', 'tomcat.service.erb')
end
