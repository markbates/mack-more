Mack::Routes.build do |r|
  
  r.with_options(:controller => :users) do |c|
    c.model_text_field_test "/users/model_text_field_test", :action => :model_text_field_test
    c.model_password_field_test "/users/model_password_field_test", :action => :model_password_field_test
    c.model_textarea_test "/users/model_textarea_test", :action => :model_textarea_test
  end
  r.resource :users
  r.resource :people_and_users
  
  r.home_page "/", :controller => :default, :action => :index
  
  r.defaults
  
end
