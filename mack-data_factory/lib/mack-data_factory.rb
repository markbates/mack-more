fl = File.dirname(__FILE__)

[:data_factory, :field_manager].each do |f|
  require File.join(fl, 'mack-data_factory', "#{f}.rb")
end

[:kernel].each do |f|
  require File.join(fl, 'mack-data_factory', 'core_extensions', "#{f}.rb")
end
