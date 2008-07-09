require 'rubygems'
require 'pathname'
require 'spec'

#gem 'mack_ruby_core_extensions', '0.2.0'

ENV["MACK_ROOT"] = File.join(File.dirname(__FILE__), "fake_application")
ENV["MACK_ENV"] = "development"

$: << File.expand_path(File.dirname(__FILE__) + "/../lib")

require 'mack'
require Pathname(__FILE__).dirname.parent.expand_path + 'lib/mack-active_record'
$genosaurus_output_directory = Mack.root

def migrations_directory
  File.join(Mack.root, "db", "migrations")
end

def cleanup(file)
  File.delete(file) if !file.nil? and File.exists?(file)
end

def fixture(file)
  File.read(File.join(File.dirname(__FILE__), "lib", "fixtures", file + ".fixtures"))
end

def config_db(adapter)
  config_file = File.join(Mack.root, "config", "database.yml")
  orig_db_yml = File.read(config_file)
  temp_db_yml = fixture("#{adapter.to_s.downcase}")
  debugger
  File.open(config_file, "w") { |f| f.write(temp_db_yml) }
  yield
  puts "reverting database.yml to: \n#{orig_db_yml}"
  File.open(config_file, "w") { |f| f.write(orig_db_yml) }
end