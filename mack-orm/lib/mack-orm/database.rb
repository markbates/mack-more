module Mack
  module Database
    
    # Sets up and establishes connections to the database based on the specified environment
    # and the settings in the database.yml file.
    def self.establish_connection(env = Mack.env)
      # raise NoMethodError.new(:establish_connection)
    end # establish_connection
    
    # Creates a database, if it doesn't already exist for the specified environment
    def self.create(env = Mack.env, repis = :default)
      # raise NoMethodError.new(:create)
    end
    
    # Drops a database, if it exists for the specified environment
    def self.drop(env = Mack.env, repis = :default)
      # raise NoMethodError.new(:drop)
    end
    
    def self.recreate(env = Mack.env, repis = :default)
      Mack::Database.drop(env, repis)
      Mack::Database.create(env, repis)
    end
    
    def self.load_structure(file, env = Mack.env, repis = :default)
      # raise NoMethodError.new(:load_structure)
    end
    
    def self.dump_structure(env = Mack.env, repis = :default)
      # raise NoMethodError.new(:dump_structure)
    end
    
  end # Database
  
end # Mack