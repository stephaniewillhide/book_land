require "rails_helper"

describe Zodiac do

  describe ".all" do
    it "is a hash of 12 zodiacs" do
      expect(Zodiac.all).to be_an_instance_of(Array)
      expect(Zodiac.all.count).to eq(12)
      Zodiac.all.each do |zodiac|
        expect(zodiac).to be_an_instance_of(Zodiac)
      end
    end
  end

  describe ".include?" do
    it "can return the correct values for Zodiacs whose start and end dates occur in order in a single year" do
      zodiac = Zodiac.new(
        name: "Ophiuchus ⛎",
        begin_month_and_day: "November 29",
        end_month_and_day: "December 17"
      )

      expect(zodiac.include?(Date.parse("2002-11-28"))).to be false

      expect(zodiac.include?(Date.parse("2002-11-29"))).to be true

      expect(zodiac.include?(Date.parse("2002-12-17"))).to be true

      expect(zodiac.include?(Date.parse("2002-12-18"))).to be false
    end

    it "can return the correct values for Zodiacs whose end date is the year after its start date" do
      zodiac = Zodiac.new(
        name: "Capricorn ♑️",
        begin_month_and_day: "December 22",
        end_month_and_day: "January 19"
      )

      expect(zodiac.include?(Date.parse("2002-12-21"))).to be false

      expect(zodiac.include?(Date.parse("2002-12-22"))).to be true

      expect(zodiac.include?(Date.parse("2002-01-19"))).to be true

      expect(zodiac.include?(Date.parse("2002-01-20"))).to be false
    end
  end
end
