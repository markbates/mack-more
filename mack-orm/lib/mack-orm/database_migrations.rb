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
        allmigs = {}
        Mack.search_path_local_first(:db).each do |path|
          Dir.glob(File.join(path, 'migrations', '*.rb')).each do |f|
            base = File.basename(f).match(/\d+_(.+)/).captures.first.downcase
            unless allmigs[base]
              allmigs[base] = f
            end
          end
        end
        allmigs.collect {|k,v| v}.sort
      end
      
    end # Migrations
  end # Database
end # Mack