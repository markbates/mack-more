require 'rubygems'
require 'genosaurus'

gem 'dm-core', '0.9.2'
require 'dm-core'
gem 'dm-validations', '0.9.2'
require 'dm-validations'
gem 'dm-migrations', '0.9.2'
require 'dm-migrations'

fl = File.dirname(__FILE__)
require File.join(fl, "database")
require File.join(fl, "helpers", "orm_helpers")
require File.join(fl, "resource")
require File.join(fl, "runner")
require File.join(fl, "test_extensions")


[:helpers, :migration_generator, :model_generator, :scaffold_generator].each do |folder|
  Dir.glob(File.join(File.dirname(__FILE__), folder.to_s, "**/*.rb")).each {|f| require f}
end
# Dir.glob(File.join(File.dirname(__FILE__), "tasks", "**/*.rake")).each {|f| load f}

English::Inflect.word 'email_address'
English::Inflect.word 'address' 

DataMapper.logger = Mack.logger

Mack::Database.establish_connection(Mack::Configuration.env)