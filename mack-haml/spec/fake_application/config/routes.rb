Mack::Routes.build do |r|

  r.with_options(:controller => "vtt/view_template") do |map|
    map.maggie_html_haml_with_layout "/vtt/maggie_html_haml_with_layout", :action => :maggie_html_haml_with_layout
    map.maggie_html_haml_without_layout "/vtt/maggie_html_haml_without_layout", :action => :maggie_html_haml_without_layout
    map.maggie_html_haml_with_special_layout "/vtt/maggie_html_haml_with_special_layout", :action => :maggie_html_haml_with_special_layout
    map.maggie_html_haml_with_haml_layout '/vtt/maggie_html_haml_with_haml_layout', :action => :maggie_html_haml_with_haml_layout
  end
  
  r.defaults
  
end
