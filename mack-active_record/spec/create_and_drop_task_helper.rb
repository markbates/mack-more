module Spec
  module CreateAndDropTask
    module Helper
      
      module Common
        
        def clear_connection
          ActiveRecord::Base.clear_active_connections!
        end
        
        def config_db(adapter)
          last_err = nil
          config_file = Mack::Paths.config("database.yml")
          orig_db_yml = File.read(config_file)
          temp_db_yml = fixture("#{adapter.to_s.downcase}")
          File.open(config_file, "w") { |f| f.write(temp_db_yml) }
          
          begin
            yield
          rescue Exception => ex
            last_err = ex
            # make sure we still execute the code below that 
            # revert the database.yml file even though there's error
          end
        
          File.open(config_file, "w") { |f| f.write(orig_db_yml) }
          File.read(config_file).should match(/sqlite3/)
          raise last_err if last_err
        end
        
        def cleanup_db_by_adapter(adapter)
          begin
            # if exists delete the db created by this task
            config_db(adapter) do
              if db_exists?("foo_development")
                # rake_task("db:drop")
                Mack::Database.drop
              elsif db_exists?("foo_test")
                Mack::Database.create("test")
                # rake_task("db:drop", {"MACK_ENV" => "test"})
              end
            end
          rescue Exception => ex
            #puts ex
          end
        end
      end
      
      module MySQL
        include Spec::CreateAndDropTask::Helper::Common

        def cleanup_db
          cleanup_db_by_adapter(:mysql)
        end
        
        private 
        
        def table_exists?(name, env = "development")
          ret_val = false
          begin
            ENV["MACK_ENV"] = env
            Mack::Database.establish_connection(env)
            result = ActiveRecord::Base.connection.execute "show tables"
            result.each do |table|
              if table[0] == name
                ret_val = true
              end
            end
          rescue Exception => ex
            ret_val = false
          end
          clear_connection
          ret_val
        end
        
        def db_exists?(name)
          ret_val = false
          ActiveRecord::Base.establish_connection(
            :adapter => "mysql",
            :host => "localhost",
            :database => "mysql",
            :username => ENV["DB_USERNAME"] || "root",
            :password => ENV["DB_PASSWORD"] || ""
          )
          res = ActiveRecord::Base.connection.execute "show databases"
          res.each do |data|
            if data[0] == name
              ret_val = true
            end
          end
          clear_connection
          ret_val
        end
      end
      
      module SQLite3
        include Spec::CreateAndDropTask::Helper::Common
        
        def cleanup_db
          cleanup_db_by_adapter(:sqlite3)
        end
        
        private
        def db_exists?(name, env = "development")
          path = Mack::Paths.db("#{name}.db")
          return File.exists?(path)
        end
      end

      module PostgreSQL
        include Spec::CreateAndDropTask::Helper::Common
    
        def cleanup_db
          cleanup_db_by_adapter(:postgresql)
        end
        
        private
        def db_exists?(name, env = "development")
          ret_val = true
          begin
            ENV["MACK_ENV"] = env
            Mack::Database.establish_connection(env)
            pg_result = ActiveRecord::Base.connection.execute "select datname from pg_database"
            pg_result.result.flatten.include?(name)
          rescue Exception => ex
            ret_val = false
          end
          ret_val
        end

      end
    end
  end
end
