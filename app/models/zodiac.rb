class Zodiac
  include ActiveModel::Model
  include ActiveModel::Attributes
  attribute :name
  attribute :begin_month_and_day
  attribute :end_month_and_day

  def self.for_date(date_of_birth)
    all.find { |zodiac| zodiac.include?(date_of_birth) }
  end

  def self.all
    {
      "Aries ♈️" => ["March 21", "April 19"],
      "Taurus ♉️" => ["April 20", "May 20"],
      "Gemini ♊️" => ["May 21", "June 20"],
      "Cancer ♋️" => ["June 21", "July 22"],
      "Leo ♌️" => ["July 23", "August 22"],
      "Virgo ♍️" => ["August 23", "September 22"],
      "Libra ♎️" => ["September 23", "October 22"],
      "Scorpio ♏️" => ["October 23", "November 21"],
      "Sagittarius ♐️" => ["November 22", "December 21"],
      "Capricorn ♑️" => ["December 22", "January 19"],
      "Aquarius ♒️" => ["January 20", "February 18"],
      "Pisces ♓️" => ["February 19", "March 20"],
    }.map do |zodiac, (begin_month_and_day, end_month_and_day)|
      Zodiac.new(
        name: zodiac,
        begin_month_and_day: begin_month_and_day,
        end_month_and_day: end_month_and_day,
      )
    end
  end

  def include?(date)
    # Capricorn spans the beginning and end of a year. For all other dates we can compare the start
    # and end dates.
    begin_date = Date.parse("#{ begin_month_and_day } #{ date.year }")
    end_date = Date.parse("#{ end_month_and_day } #{ date.year }")
    if end_date < begin_date
       date >= begin_date || date <= end_date
    else
      date.between?(begin_date, end_date)
    end
  end
end
