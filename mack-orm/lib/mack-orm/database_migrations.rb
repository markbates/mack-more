module Mack
  module Database
    module Migrations
      
      # Migrates the database to the latest version
      def self.migrate
        raise NoMethodError.new(:migrate)
      end
      
      # Rolls back the database by the specified number of steps. Default is 1
      def self.rollback(step = 1)
        raise NoMethodError.new(:rollback)
      end
      
      def self.abort_if_pending_migrations
        raise NoMethodError.new(:abort_if_pending_migrations)
      end
      
      # Returns the current version of the database
      def self.version
        raise NoMethodError.new(:version)
      end
      
      # Returns a list of the all migration files.
      def self.migration_files
        migs = []
        Mack.search_path(:db).each do |path|
          migs << Dir.glob(File.join(path, 'migrations', '*.rb'))
        end
        migs.flatten.compact.uniq
      end
      
    end # Migrations
  end # Database
end # Mack