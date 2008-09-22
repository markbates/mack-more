module Mack
  module Rendering # :nodoc:
    module Engine # :nodoc:
      class Markaby < Mack::Rendering::Engine::Base
        
        def render(io, binding)
          if io.is_a?(File)
            io = io.read
          end
          @_markaby = ::Markaby::Builder.new({}, self.view_template)
          self.view_template.instance_variable_set("@_markaby", @_markaby)
          eval(io, binding)
        end
        
        def extension
          :mab
        end
        
        module ViewHelpers
          def mab
            @_markaby
          end
        end
        
      end
    end
  end
end

Mack::Rendering::ViewTemplate.send(:include, Mack::Rendering::Engine::Markaby::ViewHelpers)
# Register the engine with Mack's Renderer Registry
Mack::Rendering::Engine::Registry.instance.register(:action, :markaby)