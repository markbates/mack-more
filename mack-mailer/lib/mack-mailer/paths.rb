module Mack # :nodoc:
  module Paths
    
    # The path to the app/mailers directory.
    def self.mailers(*args)
      File.join(Mack.root, "app", "mailers", args)
    end
    
    # The path to the app/mailers/templates directory.
    def self.mailer_templates(*args)
      Mack::Paths.mailers("templates", args)
    end
    
  end
end