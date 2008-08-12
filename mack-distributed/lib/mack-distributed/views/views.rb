module Mack
  module Distributed
    class Views
      
      include Singleton
      include DRbUndumped
      
      def get(resource)
        if File.exists?(resource)
          return File.read(resource)
        end
        return ""
      end
      
      private
      def find_engine(e)
        eval("Mack::Rendering::Engine::#{e.to_s.camelcase}")
      end
      
      
      public
      
      class << self
        def register
          if app_config.mack.share_views
            raise Mack::Distributed::Errors::ApplicationNameUndefined.new if app_config.mack.distributed_app_name.nil?
            Mack.logger.info "Registering Mack::Distributed::Views for '#{app_config.mack.distributed_app_name}' with Rinda"
            
            Mack::Distributed::Utils::Rinda.register_or_renew(:space => app_config.mack.distributed_app_name.to_sym,
                                                              :klass_def => :distributed_views, 
                                                              :object => Mack::Distributed::Views.instance)
          end
        end
        
        def ref(app_name)          
          begin
            obj = Mack::Distributed::Utils::Rinda.read(:space => app_name.to_sym, 
                                                       :klass_def => :distributed_views)
            return obj
          rescue Rinda::RequestExpiredError => er
            Mack.logger.warn(er)
          end
          
          return nil
        end
        
        # def register_files
        #   if app_config.mack.share_layouts
        #     raise Mack::Distributed::Errors::ApplicationNameUndefined.new if app_config.mack.distributed_app_name.nil?
        #     
        #     base = File.join(Mack.root, "app", "views", "**", "*.*")
        #     Mack.logger.info "Registering Distributed View Files for #{app_config.mack.distributed_app_name}:"
        #     Dir.glob(base) do |file|
        #       file_name = File.basename(file)              
        #       resource = file[Mack.root.size+1, file.size-1]
        #       
        #       Mack.logger.info "  * :space => #{app_config.mack.distributed_app_name.to_sym}, :klass_def => #{resource}, :object => #{File.read(file)}"
        #       Mack::Distributed::Utils::Rinda.register_or_renew(:space => app_config.mack.distributed_app_name.to_sym, 
        #                                                         :klass_def => resource, 
        #                                                         :object => File.read(file), :timeout => 0)
        #     end
        #   end
        # end
      end
    end
  end
end