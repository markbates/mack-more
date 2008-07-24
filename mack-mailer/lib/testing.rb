if Mack.env == "test"
  
  def delivered_emails
    Mack::Mailer::DeliveryHandlers::Test::EmailRegistry.registered_items
  end
  
  module Spec # :nodoc:
    module Example # :nodoc:
      module ExampleMethods # :nodoc:
        include Mack::Routes::Urls
        include Mack::Testing::Helpers

        alias_method :email_spec_execute, :execute

        def execute(options, instance_variables)
          @__res = email_spec_execute(options, instance_variables)
          Mack::Mailer::DeliveryHandlers::Test::EmailRegistry.reset!
          @__res
        end

      end # ExampleMethods
    end # Example
  end # Spec
  
  module Test # :nodoc:
    module Unit # :nodoc:
      class TestCase # :nodoc:

        # Let's alias the run method in the class above us so we can create a new one here
        # but still reference it.
        alias_method :super_run, :run # :nodoc:

        # We need to wrap the run method so we can do things like
        # run a cleanup method if it exists
        def run(result, &progress_block) # :nodoc:
          @__res = super_run(result)
          Mack::Mailer::DeliveryHandlers::Test::EmailRegistry.reset!
          @__res
        end

      end # TestCase
    end # Unit
  end # Test
  
end