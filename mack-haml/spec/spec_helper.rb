# require 'rubygems'
gem 'rspec'
require 'spec'
require 'rake'
require 'fileutils'

ENV["MACK_ENV"] = "test"
ENV["MACK_ROOT"] = File.join(File.dirname(__FILE__), "fake_application")

if $genosaurus_output_directory.nil?
  $genosaurus_output_directory = ENV["MACK_ROOT"]
  # puts "$genosaurus_output_directory: #{$genosaurus_output_directory}"
end

$: << File.expand_path(File.dirname(__FILE__) + "/../lib")

# load the mack framework:
require 'mack'

# not quite sure why, but when you run rake you need to keep reloading the routes. this doesn't seem
# to be a problem when running script/server or when running an individual test.
require(File.join(File.dirname(__FILE__), "fake_application", "config", "routes.rb"))

require Pathname(__FILE__).dirname.parent.expand_path + 'lib/mack-haml'

#-------------- HELPER MODULES --------------------------#

def fixture(file_name)
  File.read(File.join(File.dirname(__FILE__), "fixtures", file_name))
end

def validate_content(file_name)
  response.body.should == fixture(file_name)
end