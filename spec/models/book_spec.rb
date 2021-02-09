require "rails_helper"

describe Book do
  before do
    Book.delete_all
  end

  describe ".ordered" do
    it "orders records by name ASC" do
      beloved = Book.create!(name: "Beloved", isbn: 1987654321)
      animal_farm = Book.create!(name: "Animal Farm", isbn: 1234567890)

      expect(described_class.ordered).to eq([animal_farm, beloved])
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

  it "validates that a Book has a name", :focus do
    book = Book.new

    book.valid?
    expect(book.errors[:name]).to eq(["can't be blank"])

    book.name = "Test Book"
    book.valid?
    expect(book.errors[:name]).to eq([])
  end

  it "validates ISBN", :focus do
    book = Book.new

    book.valid?
    expect(book.errors[:isbn]).to eq(["can't be blank"])

    book.isbn = 1234567891
    book.valid?
    expect(book.errors[:isbn]).to eq([])

    book.isbn = 12345678911
    book.valid?
    expect(book.errors[:isbn]).to eq(["is the wrong length (should be 10 or 13 characters)"])

    book.isbn = 123456789
    book.valid?
    expect(book.errors[:isbn]).to eq(["is the wrong length (should be 10 or 13 characters)"])

    book.isbn = 123456789111
    book.valid?
    expect(book.errors[:isbn]).to eq(["is the wrong length (should be 10 or 13 characters)"])

    book.isbn = 1234567891111
    book.valid?
    expect(book.errors[:isbn]).to eq([])

    book.isbn = 12345678911111
    book.valid?
    expect(book.errors[:isbn]).to eq(["is the wrong length (should be 10 or 13 characters)"])
  end
end
