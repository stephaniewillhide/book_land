require "rails_helper"

describe Author do
  before do
    Author.delete_all
  end

  describe ".ordered" do
    it "orders records by name ASC" do
      bell_hooks = Author.create!(name: "bell hooks", biography: "Lorem ipsum", publisher_name: "Penguin Books", publisher_email: "info@penguin.com")
      anne_frank = Author.create!(name: "Anne Frank", biography: "Lorem ipsum", publisher_name: "Penguin Books", publisher_email: "info@penguin.com")
      agatha_christie = Author.create!(name: "agatha christie", biography: "Lorem ipsum", publisher_name: "Penguin Books", publisher_email: "info@penguin.com")

      expect(described_class.ordered).to eq([agatha_christie, anne_frank, bell_hooks])
    end
  end

  describe ".search" do
    subject { described_class.search(search_term) }

    let!(:james_baldwin) { Author.create!(name: "James Baldwin", biography: "Lorem ipsum", publisher_name: "Penguin Books", publisher_email: "info@penguin.com") }
    let!(:jane_austin) { Author.create!(name: "Jane Austin", biography: "Test bio", publisher_name: "Classic Books", publisher_email: "info@classic.com") }

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
      author = Author.create!(name: "James Baldwin", biography: "James Baldwin was an American novelist, playwright, essayist, poet, and activist.", publisher_name: "Penguin Books", publisher_email: "info@penguin.com")
      expect(author.number_of_books_per_genre).to eq({ })

      drama = Genre.create!(name: "Drama")
      comedy = Genre.create!(name: "Comedy")

      Book.create!(name: "Emma", isbn: 9292929292, created_at: Date.new(2000, 1, 1), authors: [author], genres: [drama, comedy])
      author.reload
      expect(author.number_of_books_per_genre).to eq({ drama.name => 1, comedy.name => 1,})

      author2 = create(:author, name: "Isabel Allende")
      create(:book, authors: [author2], genres: [drama, comedy])

      author.reload
      author2.reload

      # Ensures that a creation of a new book does not change the original author
      expect(author.number_of_books_per_genre).to eq({ drama.name => 1, comedy.name => 1,})
    end
  end

  describe ".bibliography" do
    it "Returns a human readable string containing an Author's bibliography" do

      author = Author.create!(name: "James Baldwin", biography: "James Baldwin was an American novelist, playwright, essayist, poet, and activist.", publisher_name: "Penguin Books", publisher_email: "info@penguin.com")
      expect(author.bibliography).to eq("")

      drama = Genre.create!(name: "Drama")
      comedy = Genre.create!(name: "Comedy")

      Book.create!(name: "Emma", isbn: 9292929292, created_at: Date.new(2000, 1, 1), authors: [author], genres: [drama, comedy])
      author.reload
      expect(author.bibliography).to eq("James Baldwin: January 2000 Emma (Drama, Comedy)")
    end
  end

  describe ".to_csv" do
    it "Exports the appropriate content" do
      dracula = Author.create!(name: "James Baldwin", biography: "Lorem ipsum", publisher_name: "Penguin Books", publisher_email: "info@penguin.com")
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
end
