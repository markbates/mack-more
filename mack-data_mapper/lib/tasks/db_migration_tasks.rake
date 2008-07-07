require 'rake'
namespace :db do
  

  
  desc "Migrate the database through scripts in db/migrations"
  task :migrate => "mack:environment" do
    require 'migration_runner'
    include DataMapper::Types
    migration_files.each { |mig| load mig }
    DataMapper::MigrationRunner.migrate_up!
  end # migrate
  
  desc "Rolls the schema back to the previous version. Specify the number of steps with STEP=n"
  task :rollback => ["mack:environment", "db:abort_if_pending_migrations"] do
    require 'dm-core/types'
    require 'migration_runner'
    include DataMapper::Types
    migration_files.each { |mig| load mig }
    step = (ENV["STEP"] || 1).to_i
    size = DataMapper::MigrationRunner.migrations.size
    index = size - step
    if index < 0
      DataMapper::MigrationRunner.migrate_down!
    else
      DataMapper::MigrationRunner.migrations[index].perform_down
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
  
  def migration_number(migration)
    migration.match(/(^\d+)/).captures.last.to_i
  end
  
  def migration_name(migration)
    migration.match(/^\d+_(.+)/).captures.last
  end
  
end # db