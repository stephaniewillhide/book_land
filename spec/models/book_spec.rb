require "rails_helper"

describe Book do
  before do
    Book.delete_all
  end

  describe ".ordered" do
    it "orders records by name ASC" do
      beloved = create(:book, name: "Beloved")
      beowulf = create(:book, name: "beowulf")
      animal_farm = create(:book, name: "Animal Farm")
      angelas_ashes = create(:book, name: "angela's ashes")

      expect(described_class.ordered).to eq([angelas_ashes, animal_farm, beloved, beowulf])
    end
  end

  describe ".featured" do
    subject { described_class.featured }

    let(:featured_book) { create(:book, featured: true) }
    let(:not_featured_book) { create(:book, featured: false) }

    it { is_expected.to include(featured_book) }
    it { is_expected.not_to include(not_featured_book) }
  end

  describe ".search" do
    subject { described_class.search(search_term) }

    let!(:emma) { create(:book, name: "Emma", isbn: 9292929292) }
    let!(:freedom) { create(:book, name: "Freedom", isbn: 1919191919) }

    describe "searching by name" do
      let(:search_term) { "emm" }

      it { is_expected.to include(emma) }
      it { is_expected.not_to include(freedom) }
    end

    describe "empty search" do
      let(:search_term) { "" }

      it { is_expected.to include(emma) }
      it { is_expected.to include(freedom) }
    end

    describe "non-matching search" do
      let(:search_term) { "lsk4jfld9skj" }

      it { is_expected.not_to include(emma) }
      it { is_expected.not_to include(freedom) }
    end

    describe "searching by ISBN" do
      let(:search_term) { "1919" }

      it { is_expected.not_to include(emma) }
      it { is_expected.to include(freedom) }
    end
  end

  describe ".to_csv" do
    it "Exports the appropriate content" do
      dracula = create(:book, name: "Dracula", isbn: 8787878787, featured: false)
      csv = Book.to_csv.split("\n")
      header = csv[0]
      data = csv[1]

      expect(header).to eq("name,isbn,featured")
      expect(data).to eq("Dracula,8787878787,false")
    end
  end

  describe ".leap_year" do
    it "Determines whether or not the book was written in a leap year" do
      book = Book.new

      # 2000 is divisible by 4, 100, and 400
      book.created_at = Date.new(2000, 1, 1)

      expect(book.leap_year?).to eq(true)

      # 1700 is divisible by 4 and divisible by 100 but not divisible by 400
      book.created_at = book.created_at.change(year: 1700)

      expect(book.leap_year?).to eq(false)

      # 2016 is divisible by 4 and not divisible by 100
      book.created_at = book.created_at.change(year: 2016)

      expect(book.leap_year?).to eq(true)

      # 2111 is not divisible by 4
      book.created_at = book.created_at.change(year: 2111)

      expect(book.leap_year?).to eq(false)
    end
  end

  describe ".count_in_leap_years" do
    it "Determines how many books were created during a leap year" do
      book = create(:book, created_at: Date.new(2000, 1, 1))

      expect(Book.count_in_leap_years).to eq(1)

      book.update!(created_at: Date.new(1700, 1, 1))

      expect(Book.count_in_leap_years).to eq(0)

      book.update!(created_at: Date.new(2016, 1, 1))

      expect(Book.count_in_leap_years).to eq(1)

      book.update!(created_at: Date.new(2111, 1, 1))

      expect(Book.count_in_leap_years).to eq(0)
    end
  end

  describe ".count_per_year" do
    it "Determines how many books were created per year" do
      expect(Book.count_per_year).to eq({ })
      create(:book, created_at: Date.new(2000, 1, 1))

      expect(Book.count_per_year).to eq({ 2000 => 1})

      create(:book, created_at: Date.new(2021, 12, 31))

      expect(Book.count_per_year).to eq({ 2000 => 1, 2021 => 1})
    end
  end

  describe ".count_in_years" do
    it "Determines how many books were created per year out of a list of provided years" do
      # When we have no books, the value for every year is zero
      expect(Book.count_in_years(2000, 2019, 2020)).to eq({ 2000 => 0, 2019 => 0, 2020 => 0,})

      create(:book, created_at: Date.new(2000, 1, 1))

      # Adding one book updates the value appropriately
      expect(Book.count_in_years(2000, 2019, 2020)).to eq({ 2000 => 1, 2019 => 0, 2020 => 0,})

      create(:book, created_at: Date.new(2021, 1, 1))

      # No years in the method works as expected
      expect(Book.count_in_years()).to eq({})

      # The same year entered twice only yields one result
      expect(Book.count_in_years(2000, 2000)).to eq({ 2000 => 1 })
    end
  end

  describe ".per_month" do
    it "Determines how many books were created each month during a given year" do
      default_monthly_values = { "January" => 0, "February" => 0, "March" => 0, "April" => 0, "May" => 0, "June" => 0, "July" => 0, "August" => 0, "September" => 0, "October" => 0, "November" => 0, "December" => 0,}

      # When we have no books, the value for every month is zero
      expect(Book.per_month(2000)).to eq(default_monthly_values)

      create(:book, created_at: Date.new(2000, 1, 1))

      # Adding one book updates the value appropriately
      expect(Book.per_month(2000)).to eq(default_monthly_values.merge({ "January" => 1 }))

      create(:book, created_at: Date.new(2000, 2, 1))

      # Adding a second book updates the value appropriately
      expect(Book.per_month(2000)).to eq(default_monthly_values.merge({ "January" => 1, "February" => 1 }))

      # Add a book with an incorrect year does not affect hash
      create(:book, created_at: Date.new(2001, 2, 1))

      expect(Book.per_month(2000)).to eq(default_monthly_values.merge({ "January" => 1, "February" => 1 }))
    end
  end

  it "validates that a Book has a name" do
    book = Book.new

    book.valid?
    expect(book.errors[:name]).to eq(["can't be blank"])

    book.name = "Test Book"
    book.valid?
    expect(book.errors[:name]).to eq([])
  end

  it "validates the uniqueness of the ISBN" do
    book1 = create(:book, name: "Beloved", isbn: 1987654321)
    book2 = Book.new
    book2.isbn = book1.isbn
    book2.valid?
    expect(book2.errors[:isbn]).to eq(["has already been taken"])
  end

  it "validates the ISBN is present and exactly 10 or 13 characters" do
    book = Book.new

    book.valid?
    expect(book.errors[:isbn]).to eq(["can't be blank"])

    [10, 13].each do |number_of_characters|
      book.isbn = "1" * number_of_characters
      book.valid?
      expect(book.errors[:isbn]).to eq([])

      [number_of_characters - 1, number_of_characters + 1].each do |invalid_number_of_characters|
        book.isbn = "1" * invalid_number_of_characters
        book.valid?
        expect(book.errors[:isbn]).to eq(["is the wrong length (should be 10 or 13 characters)"])
      end
    end
  end
end
