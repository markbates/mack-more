base = File.join(File.dirname(__FILE__), "mack-distributed")

config = {}
config["mack::share_routes"] = false if app_config.mack.share_routes.nil?
config["mack::share_objects"] = false if app_config.mack.share_objects.nil?
config["mack::distributed_app_name"] = String.randomize(10) if app_config.mack.distributed_app_name.nil?
config["mack::distributed_site_domain"] = "http://localhost:3000" if app_config.mack.distributed_site_domain.nil?
config["mack::drb_timeout"] = 0 if app_config.mack.drb_timeout.nil?
app_config.load_hash(config, "mack-distributed")

# load *.rb files
Dir.glob(File.join(base, "**", "*.rb")).each do |f|
  load(f)
end

# load tasks
Dir.glob(File.join(base, "tasks", "*.rake")).each do |f|
  load(f)
end