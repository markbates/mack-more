config = {
  :mack => {
    :caching => {
      :use_page_caching => false
    }
  },
  :cachetastic_default_options => {
    :debug => false,
    :adapter => "local_memory",
    :expiry_time => 300,
    :logging => {
      :logger_1 => {
        :type => "file",
        :file => Mack::Paths.log("cachetastic.log")
      }
    }
  }
}

if Mack.env == "production"
  config.merge!(
  :cachetastic_caches_mack_session_cache_options => {
    :debug => false,
    :adapter => "file",
    :store_options => 
      {:dir => Mack::Paths.tmp},
    :expiry_time => 14400,
    :logging => {
      :logger_1 => {
        :type => "file",
        :file => Mack::Paths.log("cachetastic_caches_mack_session_cache.log")
      }
    }
  })
end
configatron.configure_from_hash(config.recursive_merge(configatron.to_hash))

require File.join(File.dirname(__FILE__), "mack-caching", "sessions", "cachetastic_session_store")
require File.join(File.dirname(__FILE__), "mack-caching", "errors")
require File.join(File.dirname(__FILE__), "mack-caching", "page_caching", "page_caching")