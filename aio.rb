# APACHE COMMONS IO TEST CODE

# Imports ApacheCommons-IO
require 'class/commons-io.jar'
module ApacheCommonsIO
  include_package "org.apache.commons.io"  
end

char = ApacheCommonsIO::CharSequenceReader.new

#a = ApacheCommonsIO::CharSequenceReader.new

puts char.class
puts char.inspect
puts "char = #{char}"