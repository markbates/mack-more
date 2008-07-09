require 'rake'
namespace :db do
  

  
  desc "Migrate the database through scripts in db/migrations"
  task :migrate => "mack:environment" do
    require 'migration_runner'
    include DataMapper::Types
    DataMapper::MigrationRunner.reset!
    migration_files.each { |mig| load mig }
    DataMapper::MigrationRunner.migrate_up!
  end # migrate
  
  desc "Rolls the schema back to the previous version. Specify the number of steps with STEP=n"
  task :rollback => ["mack:environment", "db:abort_if_pending_migrations"] do
    require 'dm-core/types'
    require 'migration_runner'
    include DataMapper::Types
    DataMapper::MigrationRunner.reset!
    migration_files.each { |mig| load mig }
    step = (ENV["STEP"] || 1).to_i
    migrations = DataMapper::MigrationRunner.migrations.sort.reverse
    step.times do |i|
      migrations[migrations.size - (i + 1)].perform_down
    end
  end # rollback
  
  desc "Raises an error if there are pending migrations"
  task :abort_if_pending_migrations do
    require 'dm-core/types'
    require 'migration_runner'
    migration_files.each { |mig| load mig }
    DataMapper::MigrationRunner.migrations.each do |mig|
      raise Mack::Errors::UnrunMigrations.new(mig.name) if mig.send("needs_up?")
    end
    DataMapper::MigrationRunner.migrations.clear
  end
  
  private
  
  def migration_files
    Dir.glob(File.join(Mack.root, "db", "migrations", "*.rb"))
  end
  
end # db