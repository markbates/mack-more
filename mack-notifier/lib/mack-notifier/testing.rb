if Mack.env == "test"
  
  # Used for testing this method will return any emails that have been 'sent' using Mack::Notifier::DeliveryHandlers::Test.
  # These emails will get 'flushed' after each test.
  def delivered_notifiers
    Mack::Notifier::DeliveryHandlers::Test::NotifierRegistry.registered_items
  end
  
  module Spec # :nodoc:
    module Example # :nodoc:
      module ExampleMethods # :nodoc:
        include Mack::Routes::Urls
        include Mack::Testing::Helpers
        
        alias_instance_method :execute, :email_spec_execute

        def execute(options, instance_variables)
          @__res = email_spec_execute(options, instance_variables)
          Mack::Notifier::DeliveryHandlers::Test::NotifierRegistry.reset!
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
        alias_instance_method :run, :super_run

        # We need to wrap the run method so we can do things like
        # run a cleanup method if it exists
        def run(result, &progress_block) # :nodoc:
          @__res = super_run(result)
          Mack::Notifier::DeliveryHandlers::Test::NotifierRegistry.reset!
          @__res
        end

      end # TestCase
    end # Unit
  end # Test
  
end