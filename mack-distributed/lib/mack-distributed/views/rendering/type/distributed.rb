module Mack
  module Rendering
    module Type
      class Distributed < Mack::Rendering::Type::Base

        # render(:distributed, "distributed://host/resource")
        def render
          uri = Addressable::URI.parse(self.render_value)
          raise InvalidAddressableURIFormat.new("#{self.render_value}") if uri.host.nil? or uri.path.nil?
          
          app_name = uri.host
          resource = File.join("app", "views", uri.path)
          
          # first try to find the erb version of the view file, before we loop through the engine list
          view_path = "#{resource}.#{self.options[:format]}.erb"
          
          raw = nil
          
          # there's no erb version of the file, so perform the lookup for each engine registered
          Mack::Rendering::Engine::Registry.engines[:distributed].each do |e|
            debugger
            @engine = find_engine(e).new(self.view_template)

            view_path = "#{resource}.#{self.options[:format]}.#{@engine.extension}"
            raw = find_distributed_file(app_name, view_path)
            
            break if !raw.nil?
          end

          raise Mack::Errors::ResourceNotFound.new("#{self.options[:distributed]}") if raw.nil?
          
          self.view_template.render_value = raw
          Mack::Rendering::Type::Inline.new(self.view_template).render
        end
        
        private
        def find_distributed_file(app_name, file_path)
          raw = nil          
          begin
            raw = Mack::Distributed::Utils::Rinda.read(:space => app_name.to_sym, :klass_def => file_path)
          rescue Rinda::RequestExpiredError => er
            Mack.logger.warn(er)
          end
          return raw
        end
        
      end
    end
  end
end

Mack::Rendering::Engine::Registry.register(:distributed, :builder)
Mack::Rendering::Engine::Registry.register(:distributed, :erubis)
