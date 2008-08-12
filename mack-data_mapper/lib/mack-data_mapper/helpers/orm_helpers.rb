module Mack
  module ViewHelpers # :nodoc:
    module DataMapperHelpers

      DEFAULT_PARTIAL = %{
<div class="errorExplanation" id="errorExplanation">
  <h2><%= pluralize_word(errors.size, "error") %> occured.</h2>
  <ul>
    <% for error in errors %>
      <li><%= error %></li>
    <% end %>  
  </ul>
</div>
}.strip unless Mack::ViewHelpers::DataMapperHelpers.const_defined?("DEFAULT_PARTIAL")
      
      # Provides view level support for printing out all the errors associated with the
      # models you tell it. 
      # The DEFAULT_PARTIAL constant provides a simple, default, set of HTML for displaying
      # the errors. If you wish to change this HTML there are two simple ways of doing it.
      # First if you have a partial named: app/views/application/_error_messages.html.erb,
      # then it will use that default, and not DEFAULT_PARTIAL. The other option is to pass
      # in a path to partial as the second argument and that partial will be rendered.
      def error_messages_for(object_names = [], view_partial = nil)
        object_names = [object_names].flatten
        app_errors = []
        object_names.each do |name|
          object = instance_variable_get("@#{name}")
          if object
            if object.respond_to?(:errors)
              if object.errors.respond_to?(:full_messages)
                app_errors << object.errors.full_messages.uniq
              end
            end
          end
        end
        app_errors.flatten!
        unless app_errors.empty?
          if view_partial.nil?
            if File.exist?(File.join(Mack.root, "app", "views", "application", "_error_messages.html.erb"))
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
      
    end # OrmHelpers
  end # ViewHelpers
end # Mack