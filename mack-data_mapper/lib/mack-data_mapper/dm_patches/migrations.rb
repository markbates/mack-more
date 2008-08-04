module DataMapper # :nodoc:
  module MigrationRunner # :nodoc:
    
    def self.reset!
      @@migrations = []
    end
    
  end
end

module SQL # :nodoc:
  module Sqlite3 # :nodoc:

    def property_schema_statement(schema)
      statement = super
      statement << ' PRIMARY KEY AUTOINCREMENT' if supports_serial? && schema[:serial]
      statement
    end
 
  end
end