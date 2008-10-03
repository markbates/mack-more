namespace :assets do
  namespace :packager do
    desc "Rebuild asset bundles"
    task :rebuild => :environment do
      puts "Processing: Javascripts"
      pkg = Mack::Assets::Package.new(assets_mgr.groups_by_asset_type(:javascripts), :javascripts)
      pkg.contents.each { |p| puts "  ** Bundled #{p}.js" }
      puts "Processing: Stylesheets"
      pkg = Mack::Assets::Package.new(assets_mgr.groups_by_asset_type(:stylesheets), :stylesheets)
      pkg.contents.each { |p| puts "  ** Bundled #{p}.css"}
    end
    
    desc "Destroy asset bundles"
    task :destroy => :environment do
      assets_mgr.groups_by_asset_type(:javascripts).each do |group|
        path = Mack::Paths.javascripts(group + ".js")
        puts path
        if File.exists?(path)
          puts "removing: #{path}"
          FileUtils.rm(path)
        end
      end
      assets_mgr.groups_by_asset_type(:stylesheets).each do |group|
        path = Mack::Paths.stylesheets(group + ".css")
        puts path
        if File.exists?(path)
          puts "Removing: #{path}"
          FileUtils.rm(path)
        end
      end
    end
  end
end