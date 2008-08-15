module Mack
  module ViewHelpers # :nodoc:
    module OrmHelpers
      
      # DEPRECATED: Use Mack::ViewHelpers::FormHelpers text_field instead.
      def model_text_field(model, property, options = {}) # :nodoc:
        deprecate_method(:model_text_field, :text_field, '0.7.0')
        m_name = model.class.to_s.underscore
        text_field(model.class.to_s.underscore, property, options)
      end
      
      # DEPRECATED: Use Mack::ViewHelpers::FormHelpers password_field instead.
      def model_password_field(model, property, options = {}) # :nodoc:
        deprecate_method(:model_password_field, :password_field, '0.7.0')
        m_name = model.class.to_s.underscore
        password_field(model.class.to_s.underscore, property, options)
      end
      
      # DEPRECATED: Use Mack::ViewHelpers::FormHelpers text_area instead.
      def model_textarea(model, property, options = {}) # :nodoc:
        deprecate_method(:model_textarea, :text_area, '0.7.0')
        m_name = model.class.to_s.underscore
        text_area(model.class.to_s.underscore, property, options)
      end
      
    end # OrmHelpers
  end # ViewHelpers
end # Mack