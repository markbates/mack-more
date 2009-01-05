if Mack.env == "test"
  module Mack
    module Testing # :nodoc: 
    end
  end

  # Wrap it so we don't accidentally alias the run method n times and run out of db connections!
  run_once do

    module Mack
      module Testing
        
        # Implement this method to give transactional test support
        # to both RSpec and Test::Unit::TestCase for your ORM.
        def rollback_transaction
          yield
        end # rollback_transaction

      end # Testing
    end # Mack


    module Spec # :nodoc:
      module Example # :nodoc:
        module ExampleMethods # :nodoc:
          include Mack::Testing

          alias_instance_method :execute, :mack_spec_execute
          
          def before_spec_extension
          end
          
          def after_spec_extension
          end

          def execute(options, instance_variables)
            before_spec_extension
            unless configatron.mack.disable_transactional_tests
              rollback_transaction do
                @__res = mack_spec_execute(options, instance_variables)
              end
            else
              @__res = mack_spec_execute(options, instance_variables)
            end
            after_spec_extension
            return @__res
          end

        end # ExampleGroup
      end # Example
    end # Spec
  
    unless v1_9?
      module Test # :nodoc:
        module Unit # :nodoc:
          class TestCase # :nodoc:
            include Mack::Testing
  
            # Let's alias the run method in the class above us so we can create a new one here
            # but still reference it.
            alias_instance_method :run, :mack_test_case_run # :nodoc:
  
            # We need to wrap the run method so we can do things like
            # run a cleanup method if it exists
            def run(result, &progress_block) # :nodoc:
              rollback_transaction do
                mack_test_case_run(result, &progress_block)
              end
            end
  
          end # TestCase
        end # Unit
      end # Test
    end
  
  end
  
end