module Mack
  class Runner
    
    # alias_method :dm_custom_dispatch_wrapper, :custom_dispatch_wrapper# if self.respond_to? :custom_dispatch_wrapper
    # 
    # # Wrap all requests in a 'default' DataMapper repository block.
    # def custom_dispatch_wrapper(&block)
    #   repo = (app_config.mack.default_respository_name || "default").to_sym
    #   repository(repo) do
    #     dm_custom_dispatch_wrapper(&block)
    #   end
    # end
    
  end # Runner
end # Mack