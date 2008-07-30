module Mack # :nodoc:
  module Paths
    
    # The path to the app/notifiers directory.
    def self.notifiers(*args)
      File.join(Mack.root, "app", "notifiers", args)
    end
    
    # The path to the app/notifiers/templates directory.
    def self.notifier_templates(*args)
      Mack::Paths.notifiers("templates", args)
    end
    
  end
end