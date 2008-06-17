require 'rake'
namespace :db do
  
  desc "Create the database for your environment."
  task :create => :environment do
    Mack::Configuration.load_database_configurations(Mack::Configuration.env)
    repository(:default) do
      drop_create_database
    end
  end
  
  namespace :create do
    
    desc "Creates your Full environment. Does NOT create your production database!"
    task :all => :environment do
      Mack::Configuration.load_database_configurations("test")
      repository(:default) do
        drop_create_database
      end
      Mack::Configuration.load_database_configurations("development")
      repository(:default) do
        drop_create_database
      end
      Rake::Task["db:migrate"].invoke
    end
    
  end

end

private
def drop_create_database
  require 'pp'
  uri = repository(:default).adapter.uri
  case repository(:default).adapter.class.name
    when "DataMapper::Adapters::MysqlAdapter"
      DataMapper.setup(:tmp, {
        :adapter => "mysql",
        :host => "localhost",
        :database => "mysql",
        :username => ENV["DB_USERNAME"] || "root",
        :password => ENV["DB_PASSWORD"] || ""
      })
      repository(:tmp) do |repo|
        puts "Dropping (MySQL): #{uri.basename}"
        repo.adapter.execute "DROP DATABASE IF EXISTS `#{uri.basename}`"
        puts "Creating (MySQL): #{uri.basename}"
        repo.adapter.execute "CREATE DATABASE `#{uri.basename}` DEFAULT CHARACTER SET `utf8`"
      end
    when "DataMapper::Adapters::PostgresAdapter"
      ENV['PGHOST']     = uri.host if uri.host
      ENV['PGPORT']     = uri.port.to_s if uri.port
      ENV['PGPASSWORD'] = uri.password.to_s if uri.password

      begin
        puts "Dropping (PostgreSQL): #{uri.basename}"
        `dropdb -U "#{uri.user}" #{uri.basename}`
      rescue Exception => e
      end
      
      begin
        puts "Creating (PostgreSQL): #{uri.basename}"
        `createdb -U "#{uri.user}" #{uri.basename}`
      rescue Exception => e
      end
    when 'DataMapper::Adapters::Sqlite3Adapter'
      puts "Dropping (SQLite3): #{uri.basename}"
      db_dir = File.join(Mack::Configuration.root, "db")
      FileUtils.rm_rf(File.join(db_dir.to_s, uri.basename))
      puts "Creating (SQLite3): #{uri.basename}"
      FileUtils.mkdir_p(db_dir)
      FileUtils.touch(File.join(db_dir, uri.basename))
    else
      raise "Task not supported for '#{repository(:default).adapter.class.name}'"
  end
end