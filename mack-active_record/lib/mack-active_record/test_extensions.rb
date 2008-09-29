require "test/unit"
require 'spec'

if Mack.env == "test"
  module Mack
    module Testing # :nodoc: 
    end
  end

  # Wrap it so we don't accidentally alias the run method n times and run out of db connections!
  unless Mack::Testing.const_defined?("AR_TEST_EXTENSIONS")     
    
    module Mack
      module Testing
        AR_TEST_EXTENSIONS = 1
        
        module ActiveRecordHelpers
          def rollback_transaction
            begin
              ActiveRecord::Base.transaction do
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
        end # ActiveRecordHelpers
      end # Testing
    end # Mack

    module Spec # :nodoc:
      module Example # :nodoc:
        module ExampleMethods # :nodoc:
          include Mack::Testing::ActiveRecordHelpers

          alias_instance_method :execute, :ar_spec_execute
          
          def before_spec_extension
          end
          
          def after_spec_extension
          end

          def execute(options, instance_variables)
            before_spec_extension
            unless configatron.mack.disable_transactional_tests
              rollback_transaction do
                @__res = ar_spec_execute(options, instance_variables)
              end
            else
              @__res = ar_spec_execute(options, instance_variables)
            end
            after_spec_extension
            @__res
          end

        end # ExampleGroup
      end # Example
    end # Spec
  
    module Test # :nodoc:
      module Unit # :nodoc:
        class TestCase # :nodoc:
          include Mack::Testing::ActiveRecordHelpers
  
          # Let's alias the run method in the class above us so we can create a new one here
          # but still reference it.
          alias_instance_method :run, :ar_test_case_run # :nodoc:
  
          # We need to wrap the run method so we can do things like
          # run a cleanup method if it exists
          def run(result, &progress_block) # :nodoc:
            unless configatron.mack.disable_transactional_tests
              rollback_transaction do
                ar_test_case_run(result, &progress_block)
              end
            else
              ar_test_case_run(result, &progress_block)
            end
          end
  
        end # TestCase
      end # Unit
    end # Test
  
  end
  
end