require "test/unit"
require 'spec'

if Mack.env == "test"
  module Mack
    module Testing # :nodoc: 
    end
  end

  # Wrap it so we don't accidentally alias the run method n times and run out of db connections!
  unless Mack::Testing.const_defined?("DmTestTransactionWrapper")
  
    module Mack
      module Testing
      
        class DmTestTransactionWrapper # :nodoc:
          include DataMapper::Resource
        end
      
        module DataMapperHelpers
          def rollback_transaction
            begin
              Mack::Testing::DmTestTransactionWrapper.transaction do
              # DataMapper::Transaction.new.commit do
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


    module Spec # :nodoc:
      module Example # :nodoc:
        module ExampleMethods # :nodoc:
          include Mack::Testing::DataMapperHelpers

          alias_method :dm_spec_execute, :execute

          def execute(options, instance_variables)
            rollback_transaction do
              @__res = dm_spec_execute(options, instance_variables)
            end
            @__res
          end

        end # ExampleGroup
      end # Example
    end # Spec
  
    module Test # :nodoc:
      module Unit # :nodoc:
        class TestCase # :nodoc:
          include Mack::Testing::DataMapperHelpers
  
          # Let's alias the run method in the class above us so we can create a new one here
          # but still reference it.
          alias_method :dm_test_case_run, :run # :nodoc:
  
          # We need to wrap the run method so we can do things like
          # run a cleanup method if it exists
          def run(result, &progress_block) # :nodoc:
            rollback_transaction do
              dm_test_case_run(result, &progress_block)
            end
          end
  
        end # TestCase
      end # Unit
    end # Test
  
  end
  
end