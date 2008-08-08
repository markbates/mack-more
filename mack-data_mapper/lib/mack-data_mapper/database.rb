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

    # abcs = ActiveRecord::Base.configurations
    # case abcs[RAILS_ENV]["adapter"]
    # when "mysql", "oci", "oracle"
    #   ActiveRecord::Base.establish_connection(abcs[RAILS_ENV])
    #   File.open("db/#{RAILS_ENV}_structure.sql", "w+") { |f| f << ActiveRecord::Base.connection.structure_dump }
    # when "postgresql"
    #   ENV['PGHOST']     = abcs[RAILS_ENV]["host"] if abcs[RAILS_ENV]["host"]
    #   ENV['PGPORT']     = abcs[RAILS_ENV]["port"].to_s if abcs[RAILS_ENV]["port"]
    #   ENV['PGPASSWORD'] = abcs[RAILS_ENV]["password"].to_s if abcs[RAILS_ENV]["password"]
    #   search_path = abcs[RAILS_ENV]["schema_search_path"]
    #   search_path = "--schema=#{search_path}" if search_path
    #   `pg_dump -i -U "#{abcs[RAILS_ENV]["username"]}" -s -x -O -f db/#{RAILS_ENV}_structure.sql #{search_path} #{abcs[RAILS_ENV]["database"]}`
    #   raise "Error dumping database" if $?.exitstatus == 1
    # when "sqlite", "sqlite3"
    #   dbfile = abcs[RAILS_ENV]["database"] || abcs[RAILS_ENV]["dbfile"]
    #   `#{abcs[RAILS_ENV]["adapter"]} #{dbfile} .schema > db/#{RAILS_ENV}_structure.sql`
    # when "sqlserver"
    #   `scptxfr /s #{abcs[RAILS_ENV]["host"]} /d #{abcs[RAILS_ENV]["database"]} /I /f db\\#{RAILS_ENV}_structure.sql /q /A /r`
    #   `scptxfr /s #{abcs[RAILS_ENV]["host"]} /d #{abcs[RAILS_ENV]["database"]} /I /F db\ /q /A /r`
    # when "firebird"
    #   set_firebird_env(abcs[RAILS_ENV])
    #   db_string = firebird_db_string(abcs[RAILS_ENV])
    #   sh "isql -a #{db_string} > db/#{RAILS_ENV}_structure.sql"
    # else
    #   raise "Task not supported by '#{abcs["test"]["adapter"]}'"
    # end
    
    def self.structure_dump(env = Mack.env, repis = :default)
      adapter = repository(repis).adapter
      uri = adapter.uri
      structure = ""
      output_file = File.join(Mack.root, "db", "#{env}_#{repis}_schema_structure.sql")
      case adapter.class.name
        when /Mysql/
          sql = "SHOW FULL TABLES WHERE Table_type = 'BASE TABLE'"
          sql = "SHOW TABLES"
          adapter.query(sql).each do |res|
            show = adapter.query("SHOW CREATE TABLE #{res}").first
            structure += show.attributes["create table".to_sym]
            structure += ";\n\n"
          end
          # puts structure
          File.open(output_file, "w") {|f| f.puts structure}
        when /Postgres/
          `pg_dump -i -U "#{uri.user}" -s -x -O -f #{output_file} #{uri.basename}`
          # setup_temp(uri, "postgres")
          # repository(:tmp) do |repo|
          #   puts "Creating (PostgreSQL): #{uri.basename}"
          #   repo.adapter.execute "CREATE DATABASE #{uri.basename} ENCODING = 'utf8'"
          # end
        when /Sqlite3/
          db_dir = File.join(Mack.root, "db")
          `sqlite3 #{File.join(db_dir, uri.basename)} .schema > #{output_file}`
        else
          raise "Task not supported for '#{repository(repis).adapter.class.name}'"
      end
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