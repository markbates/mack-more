puts "***** #{File.basename(__FILE__)} ****"
# add_gem_path(File.expand_path(File.join(File.dirname(__FILE__), 'gems')))

require File.join(File.dirname(__FILE__), 'gems')

# require 'rubygems'
require 'genosaurus'

configatron.mack.set_default(:disable_transactional_tests, false)
configatron.mack.data_mapper_session_store.set_default(:expiry_time, 4.hours)
configatron.mack.data_mapper.set_default(:repository_runner_context, :default)
configatron.mack.data_mapper.set_default(:use_repository_runner, false)

require 'mack-orm'


fl = File.join(File.dirname(__FILE__), "mack-data_mapper")

$: << File.expand_path(File.join(fl, "dm_patches"))

[:core, :aggregates, :migrations, :serializer, :timestamps, :validations, :observer, :types].each do |g|
  require "dm-#{g}" unless g == :types
end

autoload :Serial, 'dm-types/serial'
autoload :Yaml, 'dm-types/yaml'

require File.join(fl, "database")
require File.join(fl, "database_migrations")
require File.join(fl, "generators")
require File.join(fl, "helpers", "orm_helpers")
require File.join(fl, "resource")
require File.join(fl, "test_extensions")
require File.join(fl, "repo_runner_helper")
require File.join(fl, "paginator")


[:helpers, :migration_generator, :model_generator, :scaffold_generator, :dm_patches, :sessions].each do |folder|
  Dir.glob(File.join(fl, folder.to_s, "**/*.rb")).each {|f| require f}
end

English::Inflect.word 'email_address'
English::Inflect.word 'address' 

module DataMapper # :nodoc:
  class Logger # :nodoc:
    
    [:debug, :info, :warn, :error, :fatal].each do |m|
      alias_instance_method m
      define_method(m) do |message|
        Mack.logger.send(m, message)
        self.send("_original_#{m}", message)
      end
    end
    
  end
end

DataMapper.logger = DataMapper::Logger.new(StringIO.new, 0)