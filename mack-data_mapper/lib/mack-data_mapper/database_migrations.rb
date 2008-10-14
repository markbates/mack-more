require 'migration_runner'
include DataMapper::Types
module Mack
  module Database
    module Migrations
      
      # Migrates the database to the latest version
      def self.migrate
        # Mack::Database.establish_connection
        ::DataMapper::MigrationRunner.reset!
        migration_files.each { |mig| load mig }
        ::DataMapper::MigrationRunner.migrate_up!
      end
      
      # Rolls back the database by the specified number of steps. Default is 1
      def self.rollback(step = 1)
        ::DataMapper::MigrationRunner.reset!
        migration_files.each { |mig| load mig }
        migrations = ::DataMapper::MigrationRunner.migrations.sort.reverse
        step.times do |i|
          migrations[migrations.size - (i + 1)].perform_down
        end
      end
      
      def self.abort_if_pending_migrations
        migration_files.each { |mig| load mig }
        ::DataMapper::MigrationRunner.migrations.each do |mig|
          raise Mack::Errors::UnrunMigrations.new(mig.name) if mig.send("needs_up?")
        end
        ::DataMapper::MigrationRunner.migrations.clear
      end
            
    end # Migrations
  end # Database
end # Mack