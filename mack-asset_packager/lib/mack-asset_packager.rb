fl = File.join(File.dirname(__FILE__), "mack-asset_packager")

[:link_helpers, :package].each do |f|
  file = File.join(fl, "#{f}.rb")
  puts "requiring #{file}"
  require file
end

module Mack
  module AssetPackage
    class Constants
      
    end
  end
end

# default configuration
configatron.mack.asset_packager.disable_bundle_merge = false