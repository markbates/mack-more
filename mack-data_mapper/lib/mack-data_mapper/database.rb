module Mack
  module Database
    
    # Sets up and establishes connections to the database based on the specified environment
    # and the settings in the database.yml file.
    def self.establish_connection(env = Mack.env)
      dbs = YAML::load(ERB.new(IO.read(File.join(Mack.root, "config", "database.yml"))).result)
      settings = dbs[env]
      settings.symbolize_keys!
      if settings[:default]
        settings.each do |k,v|
          DataMapper.setup(k, v.symbolize_keys)
        end
      else
        DataMapper.setup(:default, settings)
      end
    end # establish_connection
    
    # Creates a database, if it doesn't already exist for the specified environment
    def self.create(env = Mack.env, repis = :default)
      Mack::Database.establish_connection(env)
      create_database(repis)
    end
    
    # Drops a database, if it exists for the specified environment
    def self.drop(env = Mack.env, repis = :default)
      Mack::Database.establish_connection(env)
      drop_database(repis)
    end
    
    private
    def self.setup_temp(uri, adapter)
      DataMapper.setup(:tmp, {
        :adapter => adapter,
        :host => "localhost",
        :database => adapter,
        :username => ENV["DB_USERNAME"] || uri.user,
        :password => ENV["DB_PASSWORD"] || uri.password
      })
    end
    
    def self.create_database(repis = :default)
      uri = repository(repis).adapter.uri
      case repository(repis).adapter.class.name
        when /Mysql/
          setup_temp(uri, "mysql")
          repository(:tmp) do |repo|
            puts "Creating (MySQL): #{uri.basename}"
            repo.adapter.execute "CREATE DATABASE `#{uri.basename}` DEFAULT CHARACTER SET `utf8`"
          end
        when /Postgres/
          setup_temp(uri, "postgres")
          repository(:tmp) do |repo|
            puts "Creating (PostgreSQL): #{uri.basename}"
            repo.adapter.execute "CREATE DATABASE #{uri.basename} ENCODING = 'utf8'"
          end
        when /Sqlite3/
          db_dir = File.join(Mack.root, "db")
          puts "Creating (SQLite3): #{uri.basename}"
          FileUtils.mkdir_p(db_dir)
          FileUtils.touch(File.join(db_dir, uri.basename))
        else
          raise "Task not supported for '#{repository(repis).adapter.class.name}'"
      end
    end
    
    
    def self.drop_database(repis = :default)
      uri = repository(repis).adapter.uri
      case repository(repis).adapter.class.name
        when /Mysql/
          setup_temp(uri, "mysql")
          repository(:tmp) do |repo|
            puts "Dropping (MySQL): #{uri.basename}"
            repo.adapter.execute "DROP DATABASE IF EXISTS `#{uri.basename}`"
          end
        when /Postgres/
          setup_temp(uri, "postgres")
          repository(:tmp) do |repo|
            puts "Dropping (PostgreSQL): #{uri.basename}"
            repo.adapter.execute "DROP DATABASE IF EXISTS #{uri.basename}"
          end
        when /Sqlite3/
          puts "Dropping (SQLite3): #{uri.basename}"
          db_dir = File.join(Mack.root, "db")
          FileUtils.rm_rf(File.join(db_dir.to_s, uri.basename))
        else
          raise "Task not supported for '#{repository(repis).adapter.class.name}'"
      end
    end
    
  end # Database
  
end # Mack