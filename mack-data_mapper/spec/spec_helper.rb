require 'rubygems'
require 'pathname'
require 'spec'

ENV["_mack_root"] = File.join(File.dirname(__FILE__), "fake_application")
ENV["MACK_ENV"] = "development"

$: << File.expand_path(File.dirname(__FILE__) + "/../lib")

require 'mack'

require Pathname(__FILE__).dirname.parent.expand_path + 'lib/mack-data_mapper'
$genosaurus_output_directory = Mack.root

def migrations_directory
  File.join(Mack.root, "db", "migrations")
end

def fixture(name)
  File.read(File.join(File.dirname(__FILE__), "fixtures", "#{name}.fixture"))
end