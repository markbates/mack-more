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

# not quite sure why, but when you run rake you need to keep reloading the routes. this doesn't seem
# to be a problem when running script/server or when running an individual test.
require(File.join(File.dirname(__FILE__), "fake_application", "config", "routes.rb"))

self.send(:include, Mack::Routes::Urls)
self.send(:include, Mack::TestHelpers)

require Pathname(__FILE__).dirname.parent.expand_path + 'lib/mack-haml_renderer'

#-------------- HELPER MODULES --------------------------#

class Object
  alias_method :old_puts, :puts
  def puts(*args)
    old_puts args
  end
end
