configatron do |c|
  c.foo = 'bar'
  c.namespace(:mack) do |mack|
    mack.session_id = '_fake_application_session_id'
    mack.testing_framework = :rspec
    mack.namespace(:caching) do |caching|
      caching.use_page_caching = true
    end
  end
end