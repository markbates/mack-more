module Mack
  module Rendering
    module Type
      class Layout
      
        unless public_instance_methods.include?("old_render")
          puts "-----> Aliasing render method"
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
            
            # first try to find the erb version of the layout file, before we loop through the engine list
            layout_path = "#{resource}.#{self.options[:format]}.erb"
            raw = nil
            
            # there's no erb version of the file, so perform the lookup for each engine registered
            Mack::Rendering::Engine::Registry.engines[:layout].each do |e|
              debugger
              @engine = find_engine(e).new(self.view_template)
              layout_path = "#{resource}.#{self.options[:format]}.#{@engine.extension}"
              raw = find_distributed_layout(app_name, layout_path)
              break if !raw.nil?
            end

            raise Mack::Errors::ResourceNotFound.new("#{self.options[:layout]}") if raw.nil?
            
            self.view_template.render_value = raw
            Mack::Rendering::Type::Inline.new(self.view_template).render
          end
        end

        private
        def find_distributed_layout(app_name, layout_path)
          raw = nil          
          begin
            Mack.logger.info "Rinda.read(:space => #{app_name.to_sym}, :klass_def => #{layout_path})"
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

