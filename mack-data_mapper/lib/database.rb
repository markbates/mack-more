module Mack
  module Database
    
    def self.establish_connection(env)
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
    
    def self.create(env)
      Mack::Database.establish_connection(Mack.env)
      repository(:default) do
        drop_create_database
      end
    end
    
    private
    def self.drop_create_database
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
          # repository(:tmp) do |repo|
            puts "Dropping (MySQL): #{uri.basename}"
            repository(:tmp).adapter.execute "DROP DATABASE IF EXISTS `#{uri.basename}`"
            puts "Creating (MySQL): #{uri.basename}"
            repository(:tmp).adapter.execute "CREATE DATABASE `#{uri.basename}` DEFAULT CHARACTER SET `utf8`"
          # end
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
          db_dir = File.join(Mack.root, "db")
          FileUtils.rm_rf(File.join(db_dir.to_s, uri.basename))
          puts "Creating (SQLite3): #{uri.basename}"
          FileUtils.mkdir_p(db_dir)
          FileUtils.touch(File.join(db_dir, uri.basename))
        else
          raise "Task not supported for '#{repository(:default).adapter.class.name}'"
      end
    end
    
  end # Database
  
end # Mack