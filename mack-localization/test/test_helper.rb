require 'rubygems'
require "test/unit"

# Change the Mack environment so it points to the test application
ENV['_mack_env'] = "test"
ENV['_mack_root'] = File.join(File.dirname(__FILE__), "test_app")

require 'mack'

# place common methods, assertions, and other type things in this file so
# other tests will have access to them.