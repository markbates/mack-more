module Mack
  module Rendering
    module Type
      class Mailer < Mack::Rendering::Type::FileBase
        
        def render
          x_file = Mack::Paths.mailers(self.render_value, self.options[:format])
          render_file(x_file)
        end
        
      end # Mailer
    end # Type
  end # Rendering
end # Mack

Mack::Rendering::Engine::Registry.instance.register(:mailer, :erb)