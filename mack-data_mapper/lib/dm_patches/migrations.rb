module DataMapper # :nodoc:
  module MigrationRunner # :nodoc:
    
    def reset!
      @@migrations = []
    end
    
  end
end

module SQL # :nodoc:
  class TableCreator # :nodoc:
    class Column # :nodoc:

      def build_type(type_class)
        schema = {:name => @name, :quote_column_name => quoted_name}.merge(@opts)
        schema = @adapter.class.type_map[type_class].merge(schema)
        @adapter.property_schema_statement(schema)
      end

    end
  end
end
