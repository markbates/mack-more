class Time
  
  unless self.public_instance_methods.include?("to_date")
    if self.private_instance_methods.include?("to_date") || self.protected_instance_methods.include?("to_date")
      public :to_date
    else
      def to_date
        require 'date' # just in case
        jd = Date.__send__(:civil_to_jd, year, mon, mday, Date::ITALY)
        Date.new!(Date.__send__(:jd_to_ajd, jd, 0, 0), 0, Date::ITALY)
      end
    end
  end
  
  unless self.public_instance_methods.include?("to_datetime")
    if self.private_instance_methods.include?("to_datetime") || self.protected_instance_methods.include?("to_datetime")
      public :to_datetime
    else
      def to_datetime
        raise NoMethodError.new("to_datetime")
      end
    end
  end
  
  # Generates a random Time between the start time and the end time.
  def self.random(start_time, end_time = Time.now)
    start_time + (rand(end_time - start_time).to_i)
  end
  
end