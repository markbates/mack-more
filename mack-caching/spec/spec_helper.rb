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

$:.insert(0, File.expand_path(File.dirname(__FILE__) + "/../lib"))

# load the mack framework:
require 'mack'

# not quite sure why, but when you run rake you need to keep reloading the routes. this doesn't seem
# to be a problem when running script/server or when running an individual test.
require(File.join(File.dirname(__FILE__), "fake_application", "config", "routes.rb"))

require Pathname(__FILE__).dirname.parent.expand_path + 'lib/mack-caching'

#-------------- HELPER MODULES --------------------------#
module Mack
  module Testing # :nodoc:
    module Helpers
      
      def mack_app
        if $mack_app.nil?
          $mack_app = Rack::Recursive.new(Mack::Caching::PageCaching.new(Mack::Runner.new))
        end
        $mack_app
      end
      
    end
  end
end

# Mack::Controller::Registry.instance.controllers.each do |cont|
#   puts "cont: #{cont}"
#   cont.send(:include, Mack::Controller)
# end