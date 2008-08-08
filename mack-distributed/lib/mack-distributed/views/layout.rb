module Mack
  module Rendering
    module Type
      class Layout

        alias_method :local_render, :render

        def render
          debugger
          if !self.options[:layout].starts_with?("distributed")
            local_render
          else
            uri = Addressable::URI.parse(self.options[:layout])
            app_name = uri.host
            resource = File.join("app", "views", "layouts", uri.path)

            # first try to find the erb version of the layout file, before we loop through the engine list
            layout_path = "#{resource}.#{self.options[:format]}.erb"
            raw = find_distributed_layout(app_name, layout_path)

            if raw.nil?
              Mack::Rendering::Engine::Registry.engines[type].each do |e|
                @engine = find_engine(e).new(self.view_template)

                layout_path = "#{resource}.#{self.options[:format]}.#{@engine.extension}"
                raw = find_distributed_layout(app_name, layout_path)
              end
            end

            self.view_template.render_value = raw
            Mack::Rendering::Type::Inline.new(self.view_template).render
          end
        end

        private
        def find_distributed_layout(app_name, layout_path)
          raw = nil          
          begin
            raw = Mack::Distributed::Utils::Rinda.read(:space => app_name.to_sym, :klass_def => layout_path)
          rescue Rinda::RequestExpiredError => er
            Mack.logger.warn(er)
          end
          return raw
        end
      end
    end
  end
end

