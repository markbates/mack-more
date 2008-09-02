require 'drb/acl'
require 'addressable/uri'
require 'ruby-debug'

base = File.join(File.dirname(__FILE__), "mack-distributed")

config = {
  "mack::share_routes" => false,
  "mack::share_objects" => false,
  "mack::share_views" => false,
  "mack::distributed_app_name" => nil,
  "mack::distributed_site_domain" => "http://localhost:3000",
  "mack::drb_timeout" => 0
}
app_config.load_hash(config.merge(app_config.final_configuration_settings), "mack-distributed")

# load *.rb files
Dir.glob(File.join(base, "**", "*.rb")).each do |f|
  load(f)
end

Mack::Distributed::View.register
