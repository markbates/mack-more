module Mack
  module Database
    
    # Sets up and establishes connections to the database based on the specified environment
    # and the settings in the database.yml file.
    def self.establish_connection(env = Mack.env)
      dbs = db_settings(env)
      ActiveRecord::Base.establish_connection(dbs)
    end # establish_connection
    
    # Creates a database, if it doesn't already exist for the specified environment
    def self.create(env = Mack.env, repis = :default)
      dbs = db_settings(env)
      case dbs[:adapter]
      when "mysql"
        establish_mysql_connection
        create_mysql_db(env, dbs)
      when "postgresql"
        ENV['PGHOST']     = dbs[:host] if dbs[:host]
        ENV['PGPORT']     = dbs[:port].to_s if dbs[:port]
        ENV['PGPASSWORD'] = dbs[:password].to_s if dbs[:password]
        ActiveRecord::Base.clear_active_connections!
        create_postgresql_db(env, dbs)
      when "sqlite3"
        ActiveRecord::Base.clear_active_connections!
      end
    end
    
    # Drops a database, if it exists for the specified environment
    def self.drop(env = Mack.env, repis = :default)
      dbs = db_settings(env)
      case dbs[:adapter]
      when "mysql"
        establish_mysql_connection
        drop_mysql_db(env, dbs)
        # ActiveRecord::Base.connection.drop_database dbs[:database]
      when "postgresql"
        ENV['PGHOST']     = dbs[:host] if dbs[:host]
        ENV['PGPORT']     = dbs[:port].to_s if dbs[:port]
        ENV['PGPASSWORD'] = dbs[:password].to_s if dbs[:password]
        ActiveRecord::Base.clear_active_connections!
        drop_postgresql_db(env, dbs)
      when "sqlite3"
        ActiveRecord::Base.clear_active_connections!
        FileUtils.rm_rf(dbs[:database])
      end
    end
    
    # Loads the structure of the given file into the database
    def self.load_structure(file, env = Mack.env, repis = :default)
      Mack::Database.establish_connection(env)
      dbs = db_settings(env)
      sql = File.read(file)
      case dbs[:adapter]
      when "mysql", "sqlite3"
        sql.split(";").each do |s|
          s.strip! 
          ActiveRecord::Base.connection.execute(s) unless s.blank?
        end
      else
        ActiveRecord::Base.connection.execute(sql) unless sql.blank?
      end
    end
    
    # Dumps the structure of the database to a file.
    def self.dump_structure(env = Mack.env, repis = :default)
      Mack::Database.establish_connection(env)
      dbs = db_settings(env)
      structure = ""
      output_file = File.join(Mack.root, "db", "#{env}_schema_structure.sql")
      case dbs[:adapter]
      when "mysql"
        File.open(output_file, "w") {|f| f.puts ActiveRecord::Base.connection.structure_dump}
      when "postgresql"
        `pg_dump -i -U "#{dbs[:username]}" -s -x -O -n #{ENV["SCHEMA"] ||= "public"} -f #{output_file} #{dbs[:database]}`
      when "sqlite3"
        `sqlite3 #{dbs[:database]} .schema > #{output_file}`
      else
        raise "Task not supported for '#{dbs[:adapter]}'"
      end
    end
    
    private
    def self.db_settings(env)
      dbs = YAML::load(ERB.new(IO.read(File.join(Mack.root, "config", "database.yml"))).result)
      dbs = dbs[env]
      dbs.symbolize_keys!
      return dbs
    end
    
    def self.drop_postgresql_db(env, dbs)
      begin
        puts "Dropping (PostgreSQL): #{dbs[:database]}"
        `dropdb -U "#{dbs[:username]}" #{dbs[:database]}`
      rescue Exception => e
        puts e
      end
    end
    
    def self.create_postgresql_db(env, dbs)
      begin
        enc_option = "-E #{dbs[:encoding]}" if dbs[:encoding]
        puts "Creating (PostgreSQL): #{dbs[:database]}"
        `createdb #{enc_option} -U "#{dbs[:username]}" #{dbs[:database]}`
      rescue Exception => e
        puts e
      end
    end
    
    def self.establish_mysql_connection
      dbs = db_settings(Mack.env)
      
      # connect to mysql meta database
      ActiveRecord::Base.establish_connection(
        :adapter => "mysql",
        :host => dbs[:host] || "localhost",
        :database => "mysql",
        :username => ENV["DB_USERNAME"] || "root",
        :password => ENV["DB_PASSWORD"] || ""
      )
    end
    
    def self.create_mysql_db(env, dbs)
      if dbs[:collation]
        puts "Dropping (MySQL): #{dbs[:database]}"
        ActiveRecord::Base.connection.execute "CREATE DATABASE `#{dbs[:database]}` DEFAULT CHARACTER SET `#{dbs[:charset] || 'utf8'}` COLLATE `#{dbs[:collation]}`"
      else
        puts "Creating (MySQL): #{dbs[:database]}"
        ActiveRecord::Base.connection.execute "CREATE DATABASE `#{dbs[:database]}` DEFAULT CHARACTER SET `#{dbs[:charset] || 'utf8'}`"
      end
    end
    
    def self.drop_mysql_db(env, dbs)
      puts "Dropping (MySQL): #{dbs[:database]}"
      ActiveRecord::Base.connection.execute "DROP DATABASE IF EXISTS `#{dbs[:database]}`"
      # ActiveRecord::Base.connection.drop_database dbs[:database]
    end
    
  end # Database
end # Mack