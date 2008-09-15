configatron do |c|
  c.foo = 'bar'
  c.namespace(:mack) do |mack|
    mack.page_cache = true
    mack.share_routes = false
    mack.distributed_app_name = 'fake_app'
    mack.share_objects = true
    mack.drb_timeout = 0
    mack.testing_framework = :rspec
  end
end