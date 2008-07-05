module Mack
  module Paths
    
    def self.public
      ivar_cache do
        File.join(Mack.root, "public")
      end
    end
    
    def self.app
      ivar_cache do
        File.join(Mack.root, "app")
      end
    end

    def self.lib
      ivar_cache do
        File.join(Mack.root, "lib")
      end
    end
    
    def self.config
      ivar_cache do
        File.join(Mack.root, "config")
      end
    end
    
    def self.views
      ivar_cache do
        File.join(Mack::Paths.app, "views")
      end
    end
    
    def self.layouts
      ivar_cache do
        File.join(Mack::Paths.views, "layouts")
      end
    end
    
    def self.vendor
      ivar_cache do
        File.join(Mack.root, "vendor")
      end
    end
    
    def self.plugins
      ivar_cache do
        File.join(Mack::Paths.vendor, "plugins")
      end
    end
    
  end # Paths
end # Mack