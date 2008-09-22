module Mack
  module Rendering # :nodoc:
    module Engine # :nodoc:
      class Pdf < Mack::Rendering::Engine::Base

        def render(io, binding)
          if io.is_a?(File)
            io = io.read
          end
          @_pdf = ::PDF::Writer.new
          self.view_template.instance_variable_set("@_pdf", @_pdf)
          eval(io, binding)
          @_pdf.render
        end

        def extension
          :pdfw
        end

        module ViewHelpers
          def pdf
            @_pdf
          end
        end

      end
    end
  end
end
Mack::Rendering::ViewTemplate.send(:include, Mack::Rendering::Engine::Pdf::ViewHelpers)
Mack::Rendering::Engine::Registry.instance.register(:action, :pdf)
