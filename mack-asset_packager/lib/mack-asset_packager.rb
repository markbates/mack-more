fl = File.join(File.dirname(__FILE__), "mack-asset_packager")

[:link_helpers, :package, :cssmin].each do |f|
  file = File.join(fl, "#{f}.rb")
  # puts "requiring #{file}"
  require file
end

# default configuration
configatron.mack.asset_packager.enable_bundle_merge = true

if Mack.env == "production"
  configatron.mack.asset_packager.enable_bundle_merge = true
end