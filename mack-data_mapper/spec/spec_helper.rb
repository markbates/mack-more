require 'rubygems'
require 'pathname'
require 'spec'

ENV["_mack_root"] = File.join(File.dirname(__FILE__), "fake_application")
ENV["MACK_ENV"] = "test"

$: << File.expand_path(File.dirname(__FILE__) + "/../lib")

require 'mack'
# Mack.logger.add(Log4r::StdoutOutputter.new('console'))

require Pathname(__FILE__).dirname.parent.expand_path + 'lib/mack-data_mapper'
require Pathname(__FILE__).dirname.parent.expand_path + 'lib/mack-data_mapper_tasks'
$genosaurus_output_directory = Mack.root

require File.join(File.dirname(__FILE__), "..", "..", "mack-paths", "lib", "mack-paths")

def fixture(name)
  File.read(File.join(File.dirname(__FILE__), "fixtures", "#{name}.fixture"))
end


require "test/unit"

module Mack
  module Testing
  end
end

# Wrap it so we don't accidentally alias the run method n times and run out of db connections!
unless Mack::Testing.const_defined?("DmTestTransactionWrapper")
  
  module Mack
    module Testing
      module Helpers
        alias_method :mack_rake_task, :rake_task
        
        def rake_task(name, env = {})
          mack_rake_task(name, env, [File.join(File.dirname(__FILE__), "..", "lib", "tasks", "db_create_drop_tasks.rake"),
                                     File.join(File.dirname(__FILE__), "..", "lib", "tasks", "db_migration_tasks.rake")])
        end
      end # Helpers
      
      class DmTestTransactionWrapper
        include DataMapper::Resource
      end
      
      module DataMapperHelpers
        def rollback_transaction
          begin
            Mack::Testing::DmTestTransactionWrapper.transaction do
              yield if block_given?
              raise "Rollback!"
            end
          rescue => ex
            # we need to do this so we can throw up actual errors!
            unless ex.to_s == "Rollback!"
              raise ex
            end
          end
        end # rollback_transaction
      end # DataMapperHelpers
    end # Testing
  end # Mack


  module Spec
    module Example
      module ExampleMethods
        include Mack::Testing::DataMapperHelpers

        alias_method :spec_execute, :execute

        def execute(options, instance_variables)
          rollback_transaction do
            spec_execute(options, instance_variables)
          end
        end

      end # ExampleGroup
    end # Example
  end # Spec
  
  module Test
    module Unit # :nodoc:
      class TestCase # :nodoc:
        include Mack::Testing::DataMapperHelpers
  
        # Let's alias the run method in the class above us so we can create a new one here
        # but still reference it.
        alias_method :super_duper_run, :run # :nodoc:
  
        # We need to wrap the run method so we can do things like
        # run a cleanup method if it exists
        def run(result, &progress_block) # :nodoc:
          rollback_transaction do
            super_duper_run(result, &progress_block)
          end
        end
  
      end # TestCase
    end # Unit
  end # Test
  
end