require 'rubygems'
require 'genosaurus'

# gem 'dm-core', '0.9.2'
# require 'dm-core'
# gem 'dm-validations', '0.9.2'
# require 'dm-validations'
# gem 'dm-migrations', '0.9.2'
# require 'dm-migrations'
$: << File.expand_path(File.join(File.dirname(__FILE__), "dm_patches"))
require 'data_mapper'

fl = File.dirname(__FILE__)
require File.join(fl, "database")
require File.join(fl, "helpers", "orm_helpers")
require File.join(fl, "resource")
require File.join(fl, "runner")
require File.join(fl, "test_extensions")

require File.join(fl, "model_column")
require File.join(fl, "genosaurus_helpers")


[:helpers, :migration_generator, :model_generator, :scaffold_generator, :dm_patches].each do |folder|
  Dir.glob(File.join(File.dirname(__FILE__), folder.to_s, "**/*.rb")).each {|f| require f}
end

English::Inflect.word 'email_address'
English::Inflect.word 'address' 

module DataMapper
  class Logger
    
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

Mack::Database.establish_connection(Mack.env)