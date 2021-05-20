class LeapYear
  def initialize(date)
    @date = date
  end

  def leap_year?
    year = @date.year

    divisible_by_4 = year % 4 == 0
    not_divisible_by_100 = year % 100 != 0
    divisible_by_400 = year % 400 == 0

    (divisible_by_4 && not_divisible_by_100) || divisible_by_400
  end
end
