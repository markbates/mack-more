require 'rake'
namespace :db do
  
  desc "Create the database for your environment."
  task :create => :environment do
    drop_create_database
  end
  
  namespace :create do
    
    desc "Creates your Full environment. Does NOT create your production database!"
    task :all => :environment do
      drop_create_database("development")
      drop_create_database("test")
      ActiveRecord::Base.establish_connection(Mack::Configuration.database_configurations["development"])
      Rake::Task["db:migrate"].invoke
    end
    
  end

end

private
def drop_create_database(env = Mack.env)
  abcs = Mack::Configuration.database_configurations
  db_settings = abcs[env]
  case db_settings["adapter"]
    when "mysql"
      ActiveRecord::Base.establish_connection(
        :adapter => "mysql",
        :host => "localhost",
        :database => "mysql",
        :username => ENV["DB_USERNAME"] || "root",
        :password => ENV["DB_PASSWORD"] || ""
      )
      puts "Dropping (MySQL): #{db_settings["database"]}"
      ActiveRecord::Base.connection.execute "DROP DATABASE IF EXISTS `#{db_settings["database"]}`"
      
      if db_settings["collation"]
        puts "Dropping (MySQL): #{db_settings["database"]}"
        ActiveRecord::Base.connection.execute "CREATE DATABASE `#{db_settings["database"]}` DEFAULT CHARACTER SET `#{db_settings["charset"] || 'utf8'}` COLLATE `#{db_settings["collation"]}`"
      else
        puts "Creating (MySQL): #{db_settings["database"]}"
        ActiveRecord::Base.connection.execute "CREATE DATABASE `#{db_settings["database"]}` DEFAULT CHARACTER SET `#{db_settings["charset"] || 'utf8'}`"
      end
    when "postgresql"
      ENV['PGHOST']     = db_settings["host"] if db_settings["host"]
      ENV['PGPORT']     = db_settings["port"].to_s if db_settings["port"]
      ENV['PGPASSWORD'] = db_settings["password"].to_s if db_settings["password"]
      enc_option = "-E #{db_settings["encoding"]}" if db_settings["encoding"]

      ActiveRecord::Base.clear_active_connections!
      begin
        puts "Dropping (PostgreSQL): #{db_settings["database"]}"
        `dropdb -U "#{db_settings["username"]}" #{db_settings["database"]}`
      rescue Exception => e
      end
      
      begin
        puts "Creating (PostgreSQL): #{db_settings["database"]}"
        `createdb #{enc_option} -U "#{db_settings["username"]}" #{db_settings["database"]}`
      rescue Exception => e
      end
    when 'sqlite3'
      ActiveRecord::Base.clear_active_connections!
      FileUtils.rm_rf(db_settings["database"])
    else
      raise "Task not supported by '#{db_settings["adapter"]}'"
  end
end