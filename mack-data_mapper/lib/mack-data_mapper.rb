require 'rubygems'
require 'genosaurus'
require 'mack-orm'

configatron.mack.data_mapper_session_store.set_default(:expiry_time, 4.hours)

fl = File.join(File.dirname(__FILE__), "mack-data_mapper")

$: << File.expand_path(File.join(fl, "dm_patches"))

[:core, :aggregates, :migrations, :serializer, :timestamps, :validations, :observer, :types].each do |g|
  gem "dm-#{g}", "0.9.5"
  require "dm-#{g}" unless g == :types
end

autoload :Serial, 'dm-types/serial'
autoload :Yaml, 'dm-types/yaml'

require File.join(fl, "database")
require File.join(fl, "database_migrations")
require File.join(fl, "generators")
require File.join(fl, "helpers", "orm_helpers")
require File.join(fl, "resource")
require File.join(fl, "runner")
require File.join(fl, "test_extensions")


[:helpers, :migration_generator, :model_generator, :scaffold_generator, :dm_patches, :sessions].each do |folder|
  Dir.glob(File.join(fl, folder.to_s, "**/*.rb")).each {|f| require f}
end

English::Inflect.word 'email_address'
English::Inflect.word 'address' 

module DataMapper # :nodoc:
  class Logger # :nodoc:
    
    [:debug, :info, :warn, :error, :fatal].each do |m|
      unless method_defined?("dm_#{m}")
        eval %{
          alias_method :dm_#{m}, :#{m}
    
          def #{m}(message)
            Mack.logger.#{m}(message)
            dm_#{m}(message)
          end
        }
      end
    end
    
  end
end

DataMapper.logger = DataMapper::Logger.new(StringIO.new, 0)