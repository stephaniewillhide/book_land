require "rails_helper"
require 'database_cleaner/active_record'

DatabaseCleaner.strategy = :truncation

DatabaseCleaner.clean

describe Author do

  describe ".ordered" do
    it "orders records by name ASC" do
      bell_hooks = create(:author, name: "bell hooks")
      anne_frank = create(:author, name: "Anne Frank")
      agatha_christie = create(:author, name: "agatha christie")

      expect(described_class.ordered).to eq([agatha_christie, anne_frank, bell_hooks])
    end
  end

  describe ".search" do
    subject { described_class.search(search_term) }

    let!(:james_baldwin) { create(:author, name: "James Baldwin", publisher_name: "Penguin Books") }
    let!(:jane_austin) { create(:author, name: "Jane Austin", publisher_name: "Classic Books") }

    describe "searching by name" do
      let(:search_term) { "james" }

      it { is_expected.to include(james_baldwin) }
      it { is_expected.not_to include(jane_austin) }
    end

    describe "empty search" do
      let(:search_term) { "" }

      it { is_expected.to include(james_baldwin) }
      it { is_expected.to include(jane_austin) }
    end

    describe "non-matching search" do
      let(:search_term) { "lsk4jfld9skj" }

      it { is_expected.not_to include(james_baldwin) }
      it { is_expected.not_to include(jane_austin) }
    end

    describe "searching by publisher name" do
      let(:search_term) { "penguin" }

      it { is_expected.not_to include(jane_austin) }
      it { is_expected.to include(james_baldwin) }
    end
  end

  describe ".number_of_books_per_genre" do
    it "Determines how many books each Author wrote per Genre" do
      author = create(:author)
      expect(author.number_of_books_per_genre).to eq({ })

      drama = create(:genre, name: "Drama")
      comedy = create(:genre, name: "Comedy")

      create(:book, authors: [author], genres: [drama, comedy])

      author.reload
      expect(author.number_of_books_per_genre).to eq({ drama.name => 1, comedy.name => 1,})

      author2 = create(:author)
      create(:book, authors: [author2], genres: [drama, comedy])

      author.reload
      author2.reload

      # Ensures that a creation of a new book does not change the original author
      expect(author.number_of_books_per_genre).to eq({ drama.name => 1, comedy.name => 1,})
    end
  end

  describe ".leap_year" do
    subject { author.leap_year? }
    let(:author) { Author.new }

    before do
      leap_year_double = double(leap_year?: leap_year?)
      # When we call :new on LeapYear with author.created_at, return the leap_year_double
      allow(LeapYear).to receive(:new).with(author.created_at).and_return(leap_year_double)
    end

    context "is a leap year" do
      let(:leap_year?) { true }
      it { is_expected.to eq(true) }
    end

    context "is not a leap year" do
      let(:leap_year?) { false }
      it { is_expected.to eq(false) }
    end
  end

  describe ".bibliography" do
    it "Returns a human readable string containing an Author's bibliography" do
      author = create(:author, name: "James Baldwin")
      drama = create(:genre, name: "Drama")
      comedy = create(:genre, name: "Comedy")

      create(:book, name: "Emma", created_at: Date.new(2000, 1, 1), authors: [author], genres: [drama, comedy])
      author.reload
      expect(author.bibliography).to eq("James Baldwin: January 2000 Emma (Drama, Comedy)")
    end
  end

  describe ".to_csv" do
    it "Exports the appropriate content" do
      dracula = create(:author, name: "James Baldwin", biography: "Lorem ipsum", publisher_name: "Penguin Books", publisher_email: "info@penguin.com")
      csv = Author.to_csv.split("\n")
      header = csv[0]
      data = csv[1]

      expect(header).to eq("name,biography,publisher_name,publisher_email")
      expect(data).to eq("James Baldwin,Lorem ipsum,Penguin Books,info@penguin.com")
    end
  end

  it "validates that a Author has a name" do
    author = Author.new

    author.valid?
    expect(author.errors[:name]).to eq(["can't be blank"])

    author.name = "Test Author"
    author.valid?
    expect(author.errors[:name]).to eq([])
  end

  describe ".zodiac" do
    subject { author.zodiac }
    let(:zodiac) { Zodiac.new }
    let(:author) { Author.new(date_of_birth: Date.current) }
    before do
      allow(Zodiac).to receive(:for_date).with(author.date_of_birth).and_return(zodiac)
    end

    it { is_expected.to eq(zodiac) }
  end

  describe ".age_at_first_release" do
    it "Calculates age at first release" do
      author = create(:author, date_of_birth: "1980-12-15")
      create(:book, published_at: Date.new(2020, 12, 15), authors: [author])
      expect(author.age_at_first_release).to eq("About 40 years and 0 days")

      author2 = create(:author, date_of_birth: "1950-02-28")
      create(:book, published_at: Date.new(2020, 12, 15), authors: [author2])
      expect(author2.age_at_first_release).to eq("About 70 years and 290 days")

      author3 = create(:author, date_of_birth: "1940-12-28")
      create(:book, published_at: Date.new(2000, 12, 15), authors: [author3])
      expect(author3.age_at_first_release).to eq("About 59 years and 352 days")
    end
  end
end
