puts "***** #{File.basename(__FILE__)} ****"
add_gem_path(File.expand_path(File.join(File.dirname(__FILE__), 'gems')))

fl = File.join(File.dirname(__FILE__), "mack-asset_packager")

[:package_collection, :link_helpers, :cssmin].each do |f|
  file = File.join(fl, "#{f}.rb")
  # puts "requiring #{file}"
  require file
end

# default configuration
if Mack.env == "production"
  configatron.mack.assets.set_default(:enable_bundle_merge, true)
else
  configatron.mack.assets.set_default(:enable_bundle_merge, false)
end