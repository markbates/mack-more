require 'rubygems'
require 'pathname'
require 'spec'

ENV["MACK_ROOT"] = File.join(File.dirname(__FILE__), "fake_application")
ENV["MACK_ENV"] = "test"

$: << File.expand_path(File.dirname(__FILE__) + "/../lib")

require 'mack'
# Mack.logger.add(Log4r::StdoutOutputter.new('console'))

require Pathname(__FILE__).dirname.parent.expand_path + 'lib/mack-data_mapper'
require Pathname(__FILE__).dirname.parent.expand_path + 'lib/mack-data_mapper_tasks'
$genosaurus_output_directory = Mack.root

require File.join(File.dirname(__FILE__), "..", "..", "mack-paths", "lib", "mack-paths")

def fixture(name)
  File.read(File.join(File.dirname(__FILE__), "fixtures", "#{name}.fixture"))
end