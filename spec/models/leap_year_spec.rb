require "rails_helper"

describe LeapYear do
  describe ".leap_year" do
    it "Determines whether or not the book was written in a leap year" do
      # 2000 is divisible by 4, 100, and 400
      expect(LeapYear.new(Date.new(2000, 1, 1)).leap_year?).to eq(true)

      # 1700 is divisible by 4 and divisible by 100 but not divisible by 400
      expect(LeapYear.new(Date.new(1700, 1, 1)).leap_year?).to eq(false)

      # 2016 is divisible by 4 and not divisible by 100
      expect(LeapYear.new(Date.new(2016, 1, 1)).leap_year?).to eq(false)

      # 2111 is not divisible by 4
      expect(LeapYear.new(Date.new(2111, 1, 1)).leap_year?).to eq(false)
    end
  end
end
