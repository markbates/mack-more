namespace :cachetastic do
  
  namespace :page_cache do
    
    desc "Expires the page cache."
    task :expire_all => :environment do
      running_time do("Cachetastic::Caches::PageCache.expire_all")
        Cachetastic::Caches::PageCache.expire_all
      end
    end
    
  end
  
end