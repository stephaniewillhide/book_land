require "rails_helper"

describe Author do
  before do
    Author.delete_all
  end

  describe ".ordered" do
    it "orders records by name ASC" do
      bell_hooks = Author.create!(name: "bell hooks")
      anne_frank = Author.create!(name: "Anne Frank")
      agatha_christie = Author.create!(name: "agatha christie")

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

      it { is_expected.not_to include(james_baldwin) }
      it { is_expected.to include(jane_austin) }
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
    Author = Author.new

    Author.valid?
    expect(Author.errors[:name]).to eq(["can't be blank"])

    Author.name = "Test Author"
    Author.valid?
    expect(Author.errors[:name]).to eq([])
  end
end
