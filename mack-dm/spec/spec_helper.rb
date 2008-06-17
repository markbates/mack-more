require 'rubygems'
require 'pathname'
require 'spec'

gem 'mack_ruby_core_extensions', '0.1.28.100'

ENV["_mack_root"] = File.join(File.dirname(__FILE__), "fake_application")
ENV["MACK_ENV"] = "development"

require 'dm-core'
require 'dm-validations'
require 'dm-migrations'

$: << File.expand_path(File.dirname(__FILE__) + "/../lib")

require 'mack'

self.send(:include, Mack::Routes::Urls)
self.send(:include, Mack::TestHelpers)

require Pathname(__FILE__).dirname.parent.expand_path + 'lib/mack-dm'

def migrations_directory
  File.join(Mack::Configuration.root, "db", "migrations")
end