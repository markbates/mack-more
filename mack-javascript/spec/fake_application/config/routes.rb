Mack::Routes.build do |r|
  
  r.with_options(:controller => "vtt/view_template") do |map|
    map.bleeding_gums_murphy "/vtt/bleeding_gums_murphy", :action => :bleeding_gums_murphy, :method => :post, :format => :js
    map.bleeding_gums_murphy_with_render "/vtt/bleeding_gums_murphy_with_render", :action => :bleeding_gums_murphy_with_render, :method => :post, :format => :js
  end
    
  r.defaults
  
end
