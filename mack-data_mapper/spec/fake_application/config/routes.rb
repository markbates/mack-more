Mack::Routes.build do |r|
  
  r.with_options(:controller => :users) do |c|
    c.text_field_test "/users/text_field_test", :action => :text_field_test
    c.password_field_test "/users/password_field_test", :action => :password_field_test
    c.text_area_test "/users/text_area_test", :action => :text_area_test
  end
  r.resource :users
  r.resource :people_and_users
  
  r.home_page "/", :controller => :default, :action => :index
  
  r.defaults
  
end
