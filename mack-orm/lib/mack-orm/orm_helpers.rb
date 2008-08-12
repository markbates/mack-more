module Mack
  module ViewHelpers # :nodoc:
    module OrmHelpers
      
      # Generates a text input tag for a given model and field
      # 
      # Example:
      # model_text_field(@user, :username) # => <input id="user_username" name="user[username]" type="text" value="<@user.username's value>" />
      def model_text_field(model, property, options = {})
        m_name = model.class.to_s.underscore
        non_content_tag(:input, {:type => :text, :name => "#{m_name}[#{property}]", :id => "#{m_name}_#{property}", :value => model.send(property)}.merge(options))
      end
      
      # Generates a password input tag for a given model and field
      # 
      # Example:
      # model_password_field(@user, :password) # => <input id="user_username" name="user[username]" type="password" value="<@user.username's value>" />
      def model_password_field(model, property, options = {})
        model_text_field(model, property, {:type => :password}.merge(options))
      end
      
      def model_textarea(model, property, options = {})
        m_name = model.class.to_s.underscore
        content_tag(:textarea, {:name => "#{m_name}[#{property}]", :id => "#{m_name}_#{property}", :cols => 60, :rows => 20}.merge(options), model.send(property))
      end
      
    end # OrmHelpers
  end # ViewHelpers
end # Mack