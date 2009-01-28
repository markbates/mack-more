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
  
  class TableCreator # :nodoc:

    class Column # :nodoc:

      def build_type(type_class)
        schema = {:name => @name, :quote_column_name => quoted_name}.merge(@opts)
        schema[:serial?] = [schema[:serial?], schema[:serial], false].compact.first
        schema[:nullable?] = [schema[:nullable?], schema[:nullable], (!schema[:not_null] unless schema[:not_null].nil?), true].compact.first
        if type_class.is_a?(String)
          schema[:primitive] = type_class
        else
          schema = @adapter.class.type_map[type_class].merge(schema)
        end
        @adapter.property_schema_statement(schema)
      end
      
    end # Column

  end # TableCreator
    
end # SQL

# module DataMapper # :nodoc:
# 
#   class Migration # :nodoc:
#     include SQL
# 
#     # perform the migration by running the code in the #up block
#     def perform_up
#       result = nil
#       if needs_up?
#         # database.transaction.commit do
#           say_with_time "== Performing Up Migration ##{position}: #{name}", 0 do
#             result = @up_action.call
#           end
#           update_migration_info(:up)
#         # end
#       end
#       result
#     end
# 
#     # un-do the migration by running the code in the #down block
#     def perform_down
#       result = nil
#       if needs_down?
#         # database.transaction.commit do
#           say_with_time "== Performing Down Migration ##{position}: #{name}", 0 do
#             result = @down_action.call
#           end
#           update_migration_info(:down)
#         # end
#       end
#       result
#     end
# 
#   end # Migration
# end # DataMapper

module DataMapper # :nodoc:
  module MigrationRunner # :nodoc:

    def migrations # :nodoc:
      @@migrations ||= []
    end

  end # DataMapper
end # MigrationRunner
