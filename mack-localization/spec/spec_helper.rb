require 'rubygems'
require 'pathname'
require 'spec'

ENV["MACK_ROOT"] = File.join(File.dirname(__FILE__), "test_app")
ENV["MACK_ENV"] = "development"

$: << File.expand_path(File.dirname(__FILE__) + "/../lib")

require 'mack'

require Pathname(__FILE__).dirname.parent.expand_path + 'lib/mack-localization'