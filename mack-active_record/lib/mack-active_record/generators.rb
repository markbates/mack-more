module Mack
  module Database
    module Generators
      
      def self.controller_template_location
        File.join(File.dirname(__FILE__), "scaffold_generator", "templates", "app", "controllers", "controller.rb.template")
      end
      
    end # Generators
  end # Database
end # Mack