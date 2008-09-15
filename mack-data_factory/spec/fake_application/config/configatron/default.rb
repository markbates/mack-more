configatron do |c|
  c.foo = 'bar'
  c.namespace(:mack) do |mack|
    mack.page_cache = true
    mack.share_routes = false
    mack.distributed_app_name = 'fake_app'
    mack.js_framework = 'prototype'
  end
end