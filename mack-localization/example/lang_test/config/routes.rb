Mack::Routes.build do |r|

  r.resource 'items'
  
  r.index2 '/items2', :controller => :items, :action => "index2"
  r.items_set_lang '/items/set_lang/:id', :controller => :items, :action => "set_lang"
  r.home_page "/", :controller => :default, :action => :index
  
  r.defaults
  
end
