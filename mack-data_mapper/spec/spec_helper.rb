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

# require File.join(File.dirname(__FILE__), "..", "..", "mack-paths", "lib", "mack-paths")

def fixture(name)
  File.read(fixture_location(name))
end

def fixture_location(name)
  File.join(File.dirname(__FILE__), "fixtures", "#{name}.fixture")
end

# configatron.mack.disable_transactional_tests = true

class StringIO
  def write_method(*args)
    puts args.inspect
  end
end

DataMapper.setup(:in_memory, 'sqlite3::memory:')