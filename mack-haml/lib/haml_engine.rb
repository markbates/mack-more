module Mack
  module Rendering
    module Engine
      class Haml < Mack::Rendering::Engine::Base
        
        def render(io, binding)
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