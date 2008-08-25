module Mack
  module Rendering # :nodoc:
    module Type # :nodoc:
      class Layout
      
        unless public_instance_methods.include?("old_render")
          alias_method :old_render, :render
        end
        
        def render
          if !self.options[:layout].starts_with?("distributed")
            # this is the regular layout, so call the local_render method
            old_render
          else
            uri = Addressable::URI.parse(self.options[:layout])
            raise InvalidAddressableURIFormat.new("#{self.options[:layout]}") if uri.host.nil? or uri.path.nil?
            
            app_name = uri.host
            resource = File.join("app", "views", "layouts", uri.path)

            data = Mack::Distributed::View.ref(app_name)
            if data
              raw = ""
              Mack::Rendering::Engine::Registry.engines[:layout].each do |e|
                @engine = find_engine(e).new(self.view_template)

                layout_path = "#{resource}.#{self.options[:format]}.#{@engine.extension}"
                raw = data.get(layout_path)
                break if !raw.nil?
              end

              raise Mack::Errors::ResourceNotFound.new("#{self.options[:distributed]}") if raw.nil?

              old_render_value = self.view_template.render_value.dup
              self.view_template.render_value = raw
              Mack::Rendering::Type::Inline.new(self.view_template).render
              # self.view_template.render_value = old_render_value
            end
          end
        end
        
      end
    end
  end
end

