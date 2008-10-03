namespace :assets do
  namespace :packager do
    desc "Rebuild asset bundles"
    task :rebuild => :environment do
      Mack::Assets::PackageCollection.instance.compress_bundles
    end
    
    desc "Destroy asset bundles"
    task :destroy => :environment do
      Mack::Assets::PackageCollection.instance.destroy_compressed_bundles
    end
  end
end