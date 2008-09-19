require 'rubygems'
require 'cachetastic'

configatron.mack.caching.set_default(:use_page_caching, false)
configatron.cachetastic_default_options.set_default(:debug, false)
configatron.cachetastic_default_options.set_default(:adapter, :local_memory)
configatron.cachetastic_default_options.logging.logger_1.set_default(:type, 'file')
configatron.cachetastic_default_options.logging.logger_1.set_default(:file, Mack::Paths.log('cachetastic.log'))

if Mack.env == "production"
  configatron.cachetastic_caches_mack_session_cache_options.set_default(:debug, false)
  configatron.cachetastic_caches_mack_session_cache_options.set_default(:adapter, :file)
  configatron.cachetastic_caches_mack_session_cache_options.store_options.set_default(:dir, Mack::Paths.tmp)
  configatron.cachetastic_caches_mack_session_cache_options.set_default(:expiry_time, 14400)
  configatron.cachetastic_caches_mack_session_cache_options.logging.logger_1.set_default(:type, 'file')
  configatron.cachetastic_caches_mack_session_cache_options.logging.logger_1.set_default(:file, Mack::Paths.log("cachetastic_caches_mack_session_cache.log"))
end


require File.join(File.dirname(__FILE__), "mack-caching", "sessions", "cachetastic_session_store")
require File.join(File.dirname(__FILE__), "mack-caching", "errors")
require File.join(File.dirname(__FILE__), "mack-caching", "page_caching", "page_caching")