require 'rubygems'
require 'spec'
require 'rake'
require 'fileutils'


ENV["MACK_ROOT"] = File.join(File.dirname(__FILE__), "fake_application")
ENV["MACK_ENV"] = "test"

$: << File.expand_path(File.dirname(__FILE__) + "/../lib")
$: << File.expand_path(File.dirname(__FILE__) + "/../../mack-data_mapper/lib")

require 'mack'

require File.join(File.dirname(__FILE__), "..", "lib", "mack-orm")
