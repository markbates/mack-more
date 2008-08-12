module Mack
  module Database
    module Migrations
      
      def self.migrate
        ActiveRecord::Migrator.up(File.join(Mack.root, "db", "migrations"))
      end
      
      def self.rollback(step = 1)
        cur_version = version.to_i
        target_version = cur_version - step 
        target_version = 0 if target_version < 0
        ActiveRecord::Migrator.down(File.join(Mack.root, "db", "migrations"), target_version)
      end
      
      def self.abort_if_pending_migrations
        # not implemented
      end
            
    end # Migrations
  end # Database
end # Mack