module Mack
  module Distributed
    class Views
      class << self
        def register_files
          if app_config.mack.share_layouts
            raise Mack::Distributed::Errors::ApplicationNameUndefined.new if app_config.mack.distributed_app_name.nil?
            
            base = File.join(Mack.root, "app", "views", "**", "*.*")
            Mack.logger.info "Registering Distributed View Files for #{app_config.mack.distributed_app_name}:"
            Dir.glob(base) do |file|
              file_name = File.basename(file)              
              resource = file[Mack.root.size+1, file.size-1]
              
              Mack.logger.info "  * :space => #{app_config.mack.distributed_app_name.to_sym}, :klass_def => #{resource}, :object => #{File.read(file)}"
              Mack::Distributed::Utils::Rinda.register_or_renew(:space => app_config.mack.distributed_app_name.to_sym, 
                                                                :klass_def => resource, 
                                                                :object => File.read(file), :timeout => 0)
            end
          end
        end
      end
    end
  end
end