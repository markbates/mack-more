configatron do |c|
  c.namespace(:mack) do |mack|
    mack.session_id = '_fake_application_session_id'
    mack.testing_framework = 'test_case'
    mack.disable_transactional_tests = true
  end
end