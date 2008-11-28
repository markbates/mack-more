module Mack
  module Rendering # :nodoc:
    module Engine # :nodoc:
      # Allows use of the Builder::XmlMarkup engine to be used with rendering.
      class Rjs < Mack::Rendering::Engine::Base
        
        def render(io, binding)
          if io.is_a?(File)
            io = io.read
          end
          @_jsp_page = Mack::JavaScript::ScriptGenerator.new
          view_template.instance_variable_set("@_jsp_page", @_jsp_page)
          eval(io, binding)
          @_jsp_page.to_s
        end
        
        def extension
          :rjs
        end
        
        module ViewTemplateHelpers
          def page
            @_jsp_page
          end
        end # ViewTemplateHelpers
        
      end # RJS
    end # Engine
  end # Rendering
end # Mack

Mack::Rendering::ViewTemplate.send(:include, Mack::Rendering::Engine::Rjs::ViewTemplateHelpers)
Mack::Rendering::Engine::Registry.instance.register(:action, :rjs)
Mack::Rendering::Engine::Registry.instance.register(:template, :rjs)
Mack::Rendering::Engine::Registry.instance.register(:partial, :rjs)
Mack::Rendering::Engine::Registry.instance.register(:js, :rjs)
