require 'drb/acl'
require 'addressable/uri'
require 'ruby-debug'

base = File.join(File.dirname(__FILE__), "mack-distributed")

config = {
  :mack => {
    :distributed => {
      :share_routes => false,
      :share_objects => false,
      :share_views => false,
      :app_name => nil,
      :site_domain => 'http://localhost:3000',
      :timeout => 0
    }
  }
}
puts configatron.to_hash.inspect
configatron.configure_from_hash(config.recursive_merge(configatron.to_hash))
puts configatron.to_hash.inspect

# load *.rb files
Dir.glob(File.join(base, "**", "*.rb")).each do |f|
  load(f)
end

Mack::Distributed::View.register
