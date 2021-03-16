require "rails_helper"

describe Book do
  before do
    Book.delete_all
  end

  describe ".ordered" do
    it "orders records by name ASC" do
      beloved = Book.create!(name: "Beloved", isbn: 1987654321)
      beowulf = Book.create!(name: "beowulf", isbn: 1987654322)
      animal_farm = Book.create!(name: "Animal Farm", isbn: 1234567890)
      angelas_ashes = Book.create!(name: "angela's ashes", isbn: 1234567892)

      expect(described_class.ordered).to eq([angelas_ashes, animal_farm, beloved, beowulf])
    end
  end

  describe ".featured" do
    subject { described_class.featured }

    let(:featured_book) { Book.create!(name: "Beloved", isbn: 1987654321, featured: true) }
    let(:not_featured_book) { Book.create!(name: "Animal Farm", isbn: 1234567890, featured: false) }

    it { is_expected.to include(featured_book) }
    it { is_expected.not_to include(not_featured_book) }
  end

  describe ".search" do
    subject { described_class.search(search_term) }

    let!(:emma) { Book.create!(name: "Emma", isbn: 9292929292) }
    let!(:freedom) { Book.create!(name: "Freedom", isbn: 1919191919) }

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
      dracula = Book.create!(name: "Dracula", isbn: 8787878787, featured: false)
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
      book.created_at = Date.new(2000, 1, 1)

      expect(book.leap_year?).to eq(true)

      book.created_at = book.created_at.change(year: 1700)

      expect(book.leap_year?).to eq(false)

      book.created_at = book.created_at.change(year: 2016)

      expect(book.leap_year?).to eq(true)

      book.created_at = book.created_at.change(year: 1900)

      expect(book.leap_year?).to eq(false)

      book.created_at = book.created_at.change(year: 2100)

      expect(book.leap_year?).to eq(false)

      book.created_at = book.created_at.change(year: 2400)

      expect(book.leap_year?).to eq(true)
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
    beloved = Book.create!(name: "Beloved", isbn: 1987654321)
    book = Book.new
    book.isbn = beloved.isbn
    book.valid?
    expect(book.errors[:isbn]).to eq(["has already been taken"])
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
