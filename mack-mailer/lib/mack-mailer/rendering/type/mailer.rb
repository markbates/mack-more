module Mack
  module Rendering # :nodoc:
    module Type # :nodoc:
      class Mailer < Mack::Rendering::Type::FileBase # :nodoc:
        
        def render
          x_file = Mack::Paths.mailer_templates(self.render_value, self.options[:format])
          render_file(x_file)
        end
        
      end # Mailer
    end # Type
  end # Rendering
end # Mack

Mack::Rendering::Engine::Registry.instance.register(:mailer, :erb)