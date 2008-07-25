module DataMapper # :nodoc:
  module MigrationRunner # :nodoc:
    
    def self.reset!
      @@migrations = []
    end
    
  end
end