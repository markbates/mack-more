module Mack
  module Paths
    
    # ./public
    def self.public(*files)
      File.join(Mack.root, "public", files)
    end
    
    # ./app
    def self.app(*files)
      File.join(Mack.root, "app", files)
    end
    
    # ./app/views
    def self.views(*files)
      File.join(Mack::Paths.app, "views", files)
    end
    
    # ./app/views/layouts
    def self.layouts(*files)
      File.join(Mack::Paths.views, "layouts", files)
    end
    
    # ./app/controllers
    def self.controllers(*files)
      File.join(Mack::Paths.app, "controllers", files)
    end
    
    # ./app/models
    def self.models(*files)
      File.join(Mack::Paths.app, "models", files)
    end
    
    # ./app/helpers
    def self.helpers(*files)
      File.join(Mack::Paths.app, "helpers", files)
    end

    # ./lib
    def self.lib(*files)
      File.join(Mack.root, "lib", files)
    end
    
    # ./lib/tasks
    def self.tasks(*files)
      File.join(Mack::Paths.lib, "tasks", files)
    end
    
    # ./db
    def self.db(*files)
      File.join(Mack.root, "db", files)
    end
    
    # ./db/migrations
    def self.migrations(*files)
      File.join(Mack::Paths.db, "migrations", files)
    end
    
    # ./config
    def self.config(*files)
      File.join(Mack.root, "config", files)
    end
    
    # ./config/app_config
    def self.app_config(*files)
      File.join(Mack::Paths.config, "app_config", files)
    end
    
    # ./config/initializers
    def self.initializers(*files)
      File.join(Mack::Paths.config, "initializers", files)
    end
    
    # ./vendor
    def self.vendor(*files)
      File.join(Mack.root, "vendor", files)
    end
    
    # ./vendor/plugins
    def self.plugins(*files)
      File.join(Mack::Paths.vendor, "plugins", files)
    end
    
  end # Paths
end # Mack