module Mack
  module Rendering # :nodoc:
    module Engine # :nodoc:
      class Haml < Mack::Rendering::Engine::Base
        
        def render(io, binding)
          if io.is_a?(File)
            io = io.read
          end
          ::Haml::Engine.new(io).render(binding)
        end
        
        def extension
          :haml
        end
        
      end
    end
  end
end

# Register the engine with Mack's Renderer Registry
Mack::Rendering::Engine::Registry.instance.register(:action, :haml)
Mack::Rendering::Engine::Registry.instance.register(:layout, :haml)