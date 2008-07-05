module Mack
  module Paths
    
    # ./public
    def self.public
      ivar_cache do
        File.join(Mack.root, "public")
      end
    end
    
    # ./app
    def self.app
      ivar_cache do
        File.join(Mack.root, "app")
      end
    end
    
    # ./app/views
    def self.views
      ivar_cache do
        File.join(Mack::Paths.app, "views")
      end
    end
    
    # ./app/views/layouts
    def self.layouts
      ivar_cache do
        File.join(Mack::Paths.views, "layouts")
      end
    end
    
    # ./app/controllers
    def self.controllers
      ivar_cache do
        File.join(Mack::Paths.app, "controllers")
      end
    end
    
    # ./app/models
    def self.models
      ivar_cache do
        File.join(Mack::Paths.app, "models")
      end
    end
    
    # ./app/helpers
    def self.helpers
      ivar_cache do
        File.join(Mack::Paths.app, "helpers")
      end
    end

    # ./lib
    def self.lib
      ivar_cache do
        File.join(Mack.root, "lib")
      end
    end
    
    # ./db
    def self.db
      ivar_cache do
        File.join(Mack.root, "db")
      end
    end
    
    # ./db/migrations
    def self.migrations
      ivar_cache do
        File.join(Mack::Paths.db, "migrations")
      end
    end
    
    # ./config
    def self.config
      ivar_cache do
        File.join(Mack.root, "config")
      end
    end
    
    # ./vendor
    def self.vendor
      ivar_cache do
        File.join(Mack.root, "vendor")
      end
    end
    
    # ./vendor/plugins
    def self.plugins
      ivar_cache do
        File.join(Mack::Paths.vendor, "plugins")
      end
    end
    
  end # Paths
end # Mack