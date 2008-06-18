module Mack
  module Localization
    module DateFormatEngine
      class Base
        
        def format(time = Time.now, type = :long)
          day          = time.day
          day_of_week  = time.wday
          day_of_month = time.mday
          month        = time.month
          year         = time.year

          raise Mack::Localization::Errors::InvalidArgument.new(type) if date_format_template(type).nil?
          
          template = date_format_template(type).dup
          template.gsub!("mm", "%02d" % month.to_s)
          template.gsub!("MM", months(type)[month-1])
          template.gsub!("dd", "%02d" % day.to_s)
          template.gsub!("yyyy", year.to_s)
          template.gsub!("DD", days_of_week(type)[day_of_week-1])
          
          return template
        end

        protected 
        def date_format_template(type)
          raise "Unimplemented: date_format(type)"
        end

        def days_of_week(type)
          raise "Unimplemented: days_of_week(type)"
        end

        def months(type)
          raise "Unimplemented: month(type)"
        end

      end
    end
  end
end
