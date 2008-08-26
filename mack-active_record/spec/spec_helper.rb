require 'rubygems'
require 'pathname'
require 'spec'

#gem 'mack_ruby_core_extensions', '0.2.0'

ENV["MACK_ROOT"] = File.join(File.dirname(__FILE__), "fake_application")
ENV["MACK_ENV"] = "test"

$: << File.expand_path(File.dirname(__FILE__) + "/../lib")

require 'mack'
require Pathname(__FILE__).dirname.parent.expand_path + 'lib/mack-active_record'
$genosaurus_output_directory = Mack.root

# require File.join(File.dirname(__FILE__), "..", "..", "mack-paths", "lib", "mack-paths")

require File.join(File.dirname(__FILE__), 'create_and_drop_task_helper')

def migrations_directory
  Mack::Paths.db("migrations")
end

def cleanup(file)
  File.delete(file) if !file.nil? and File.exists?(file)
end

def fixture(name)
  File.read(fixture_location(name))
end

def fixture_location(name)
  File.join(File.dirname(__FILE__), "fixtures", "#{name}.fixture")
end
