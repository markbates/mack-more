require 'rubygems'
gem 'rspec'
require 'spec'
require 'rake'
require 'fileutils'

ENV["_mack_env"] = "test"
ENV["_mack_root"] = File.join(File.dirname(__FILE__), "fake_application")

if $genosaurus_output_directory.nil?
  $genosaurus_output_directory = ENV["_mack_root"]
  puts "$genosaurus_output_directory: #{$genosaurus_output_directory}"
end

$: << File.expand_path(File.dirname(__FILE__) + "/../lib")

# load the mack framework:
require 'mack'

require Pathname(__FILE__).dirname.parent.expand_path + 'lib/mack-paths'

#-------------- HELPER MODULES --------------------------#
