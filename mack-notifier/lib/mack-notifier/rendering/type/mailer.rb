module Mack
  module Rendering # :nodoc:
    module Type # :nodoc:
      class Notifier < Mack::Rendering::Type::FileBase # :nodoc:
        
        def render
          x_file = Mack::Paths.notifier_templates(self._render_value, self._options[:format])
          render_file(x_file)
        end
        
      end # Notifier
    end # Type
  end # Rendering
end # Mack

Mack::Rendering::Engine::Registry.instance.register(:notifier, :erb)