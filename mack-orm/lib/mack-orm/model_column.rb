module Mack
  module Genosaurus # :nodoc:
    module Orm # :nodoc:
      # Used to represent a 'column' from the param cols or columns for generators.
      class ModelColumn # :nodoc:
      
        # The name of the column.
        attr_accessor :column_name
        # The type of the column. Ie. string, integer, datetime, etc...
        attr_accessor :column_type
        # The name of the model associated with the column. Ie. user, post, etc...
        attr_accessor :model_name
      
        # Takes in the model_name (user, post, etc...) and the column (username:string, body:text, etc...)
        def initialize(model_name, column_unsplit)
          self.model_name = model_name.singular.underscore
          cols = column_unsplit.split(":")
          self.column_name = cols.first#.underscore
          self.column_type = cols.last#.underscore
        end

        # Generates the appropriate HTML form field for the type of column represented.
        # 
        # Examples:
        #   Mack::Generator::ColumnObject.new("user", "username:string").form_field 
        #     => "<%= :user.text_field :username, :label => true %>"
        #   Mack::Generator::ColumnObject.new("Post", "body:text").form_field
        #     => "<%= :post.text_area :body, :label => true %>"
        def form_field
          case self.column_type
          when "text"
            %{<%= :#{self.model_name}.text_area :#{self.column_name}, :label => true %>}
          else
            case self.column_name.downcase
            when /password/
              %{<%= :#{self.model_name}.password_field :#{self.column_name}, :label => true %>}
            else
              %{<%= :#{self.model_name}.text_field :#{self.column_name}, :label => true %>}
            end
          end
        end
      
      end # ModelColumn
    end # Orm
  end # Generator
end # Mack