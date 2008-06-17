Mack::Routes.build do |r|
  
  r.resource :users
  
  r.home_page "/", :controller => :default, :action => :index
  
  r.defaults
  
end
