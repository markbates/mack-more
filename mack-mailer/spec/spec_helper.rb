require 'rubygems'
gem 'rspec'
require 'spec'
require 'rake'
require 'fileutils'

ENV["MACK_ENV"] = "test"
ENV["MACK_ROOT"] = File.join(File.dirname(__FILE__), "fake_application")

if $genosaurus_output_directory.nil?
  $genosaurus_output_directory = ENV["MACK_ROOT"]
  puts "$genosaurus_output_directory: #{$genosaurus_output_directory}"
end

$: << File.expand_path(File.dirname(__FILE__) + "/../lib")

# load the mack framework:
require 'mack'
require File.join(File.dirname(__FILE__), "..", "..", "mack-paths", "lib", "mack-paths")
require Pathname(__FILE__).dirname.parent.expand_path + 'lib/mack-mailer'

#-------------- HELPER MODULES --------------------------#

class WelcomeEmail
  include Mack::Mailer
end

def fixture(name)
  File.read(File.join(File.dirname(__FILE__), "fixtures", "#{name}.fixture"))
end
