module Mack
  module Database
    module Migrations
      
      # Migrates the database to the latest version
      def self.migrate
        ActiveRecord::Migrator.up(Mack::Paths.db("migrations"))
      end
      
      # Rolls back the database by the specified number of steps. Default is 1
      def self.rollback(step = 1)
        cur_version = version.to_i
        target_version = cur_version - step 
        target_version = 0 if target_version < 0
        ActiveRecord::Migrator.down(Mack::Paths.db("migrations"), target_version)
      end
      
      # Not implemented
      def self.abort_if_pending_migrations
      end
      
      # Returns the current version of the database
      def self.version
        ActiveRecord::Migrator.current_version
      end
            
    end # Migrations
  end # Database
end # Mack