class Time
  
  unless self.public_instance_methods.include?("to_date")
    def to_date
      require 'date' # just in case
      jd = Date.__send__(:civil_to_jd, year, mon, mday, Date::ITALY)
      Date.new!(Date.__send__(:jd_to_ajd, jd, 0, 0), 0, Date::ITALY)
    end
  end
  
  unless self.public_instance_methods.include?("to_datetime")
    def to_datetime
      raise NoMethodError.new(:to_datetime)
    end
  end
  
end