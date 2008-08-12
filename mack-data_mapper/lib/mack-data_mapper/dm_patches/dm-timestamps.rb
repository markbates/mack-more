module DataMapper # :nodoc:
  module Timestamp # :nodoc:
    TIMESTAMP_PROPERTIES[:created_at] = lambda { |r| r.created_at = DateTime.now if r.new_record? && r.created_at.nil? }
    TIMESTAMP_PROPERTIES[:created_on] = lambda { |r| r.created_on = DateTime.now if r.new_record? && r.created_on.nil? }
  end
end