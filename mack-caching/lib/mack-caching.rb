config_defaults = {
  "cachetastic_default_options" => {
    "debug" => false,
    "adapter" => "local_memory",
    "expiry_time" => 300,
    "logging" => {
      "logger_1" => {
        "type" => "file",
        "file" => Mack::Paths.log("cachetastic.log")
      }
    }
  }
}

config = config_defaults

if Mack.env == "production"
  config.merge!(
  "cachetastic_caches_mack_session_cache_options" => {
    "debug" => false,
    "adapter" => "file",
    "store_options" => 
      {"dir" => File.join(Mack.root, "tmp")},
    "expiry_time" => 14400,
    "logging" => {
      "logger_1" => {
        "type" => "file",
        "file" => Mack::Paths.log("cachetastic_caches_mack_session_cache.log")
      }
    }
  })
end
configatron.configure_from_hash(config.merge(configatron.to_hash))


require File.join(File.dirname(__FILE__), "mack-caching", "sessions", "cachetastic_session_store")
require File.join(File.dirname(__FILE__), "mack-caching", "errors")
require File.join(File.dirname(__FILE__), "mack-caching", "page_caching", "page_caching")