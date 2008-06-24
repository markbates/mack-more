require 'rubygems'
require 'pathname'
require 'spec'

#gem 'mack_ruby_core_extensions', '0.2.0'

ENV["_mack_root"] = File.join(File.dirname(__FILE__), "fake_application")
ENV["MACK_ENV"] = "development"

$: << File.expand_path(File.dirname(__FILE__) + "/../lib")

require 'mack'

self.send(:include, Mack::Routes::Urls)
self.send(:include, Mack::TestHelpers)

def migrations_directory
  File.join(Mack::Configuration.root, "db", "migrations")
end