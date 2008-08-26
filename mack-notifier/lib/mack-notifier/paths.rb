module Mack # :nodoc:
  module Paths
    
    # The path to the app/notifiers directory.
    def self.notifiers(*args)
      Mack::Paths.app("notifiers", args)
    end
    
    # The path to the app/notifiers/templates directory.
    def self.notifier_templates(*args)
      Mack::Paths.notifiers("templates", args)
    end
    
    # The path the test/notifiers directory
    def self.notifier_tests(*args)
      Mack::Paths.test("notifiers", args)
    end
    
  end
end