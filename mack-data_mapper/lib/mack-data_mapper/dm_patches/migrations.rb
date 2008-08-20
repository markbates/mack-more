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
 
  end # Sqlite3
  
  class TableModifier # :nodoc:

    def add_column(name, type, opts = {})
      column = SQL::TableCreator::Column.new(@adapter, name, build_type(name, type), opts)
      @statements << "ALTER TABLE #{quoted_table_name} ADD COLUMN #{column.to_sql}"
    end

    def change_column(name, type, opts = {})
      # raise NotImplemented for SQLite3
      @statements << "ALTER TABLE #{quoted_table_name} ALTER COLUMN #{quote_column_name(name)} TYPE #{build_type(name, type, opts).gsub(quote_column_name(name), '').gsub('NOT NULL', '')}"
    end

    def build_type(name, type_class, options = @opts)
      schema = {:name => name.to_s, :quote_column_name => quote_column_name(name)}.merge(options)
      schema[:serial?] ||= schema[:serial]
      schema[:nullable?] ||= schema[:nullable]
      schema = @adapter.class.type_map[type_class].merge(schema)
      @adapter.property_schema_statement(schema)
    end

  end # TableModifier  
end # SQL