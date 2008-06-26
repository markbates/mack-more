Mack::Routes.build do |r|  
  
  r.with_options(:controller => "vtt/view_template") do |map|
    map.hello_pdf "/vtt/hello.pdf", :action => :hello_pdf
  end
  
  r.defaults
  
end
