module Mack
  module Paths
    
    # ./public
    def self.public(*file)
      File.join(Mack.root, "public", file)
    end
    
    # ./app
    def self.app(*file)
      File.join(Mack.root, "app", file)
    end
    
    # ./app/views
    def self.views(*file)
      File.join(Mack::Paths.app, "views", file)
    end
    
    # ./app/views/layouts
    def self.layouts(*file)
      File.join(Mack::Paths.views, "layouts", file)
    end
    
    # ./app/controllers
    def self.controllers(*file)
      File.join(Mack::Paths.app, "controllers", file)
    end
    
    # ./app/models
    def self.models(*file)
      File.join(Mack::Paths.app, "models", file)
    end
    
    # ./app/helpers
    def self.helpers(*file)
      File.join(Mack::Paths.app, "helpers", file)
    end

    # ./lib
    def self.lib(*file)
      File.join(Mack.root, "lib", file)
    end
    
    # ./db
    def self.db(*file)
      File.join(Mack.root, "db", file)
    end
    
    # ./db/migrations
    def self.migrations(*file)
      File.join(Mack::Paths.db, "migrations", file)
    end
    
    # ./config
    def self.config(*file)
      File.join(Mack.root, "config", file)
    end
    
    # ./vendor
    def self.vendor(*file)
      File.join(Mack.root, "vendor", file)
    end
    
    # ./vendor/plugins
    def self.plugins(*file)
      File.join(Mack::Paths.vendor, "plugins", file)
    end
    
  end # Paths
end # Mack