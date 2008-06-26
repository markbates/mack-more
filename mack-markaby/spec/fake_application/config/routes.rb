Mack::Routes.build do |r|

  r.resource "admin/users"
  
  r.with_options(:controller => "vtt/view_template") do |map|
    map.marge_html_markaby_with_layout "/vtt/marge_html_markaby_with_layout", :action => :marge_html_markaby_with_layout
    map.marge_html_markaby_without_layout "/vtt/marge_html_markaby_without_layout", :action => :marge_html_markaby_without_layout
    map.marge_html_markaby_with_special_layout "/vtt/marge_html_markaby_with_special_layout", :action => :marge_html_markaby_with_special_layout
  end
    
  r.defaults
  
end
