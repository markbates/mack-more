class Person < ActiveRecord::Base
  validates_presence_of :full_name
end