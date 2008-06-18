module Mack
  module ViewHelpers
    module OrmHelpers
      DEFAULT_PARTIAL = %{
<div>
  <div class="errorExplanation" id="errorExplanation">
    <h2><%= pluralize_word(errors.size, "error") %> occured.</h2>
    <ul>
      <% for error in errors %>
        <li><%= error %></li>
      <% end %>  
    </ul>
  </div>
</div>
      } unless Mack::ViewHelpers::OrmHelpers.const_defined?("DEFAULT_PARTIAL")
  
      def error_messages_for(object_names = [], view_partial = nil)
        object_names = [object_names].flatten
        app_errors = []
        object_names.each do |name|
          object = instance_variable_get("@#{name}")
          if object
            if object.is_a?(DataMapper::Resource)
              app_errors << object.errors.full_messages.uniq
            end
          end
        end
        app_errors.flatten!
        unless app_errors.empty?
          if view_partial.nil?
            if File.exist?(File.join(Mack::Configuration.views_directory, "application", "_error_messages.html.erb"))
              render(:partial, "application/error_messages", :locals => {:errors => app_errors})
            else
              render(:inline, DEFAULT_PARTIAL, :locals => {:errors => app_errors})
            end
          else        
            render(:partial, view_partial, :locals => {:errors => app_errors})
          end
        else
          ""
        end
      end
      # self.include_safely_into(Mack::ViewBinder)
    end # OrmHelpers
  end # ViewHelpers
end # Mack