require "rails_helper"

describe Genre do
  before do
    Genre.delete_all
  end

  describe ".ordered" do
    it "orders records by name ASC" do
      fantasy = create(:genre, name: "Fantasy")
      fiction = create(:genre, name: "fiction")
      adventure = create(:genre, name: "Adventure")
      anthology = create(:genre, name: "anthology")

      expect(described_class.ordered).to eq([adventure, anthology, fantasy, fiction])
    end
  end

  describe ".search" do
    subject { described_class.search(search_term) }

    let!(:mystery) { create(:genre, name: "Mystery") }
    let!(:thriller) { create(:genre, name: "Thriller") }

    describe "searching by name" do
      let(:search_term) { "myst" }

      it { is_expected.to include(mystery) }
      it { is_expected.not_to include(thriller) }
    end

    describe "empty search" do
      let(:search_term) { "" }

      it { is_expected.to include(mystery) }
      it { is_expected.to include(thriller) }
    end

    describe "non-matching search" do
      let(:search_term) { "lsk4jfld9skj" }

      it { is_expected.not_to include(mystery) }
      it { is_expected.not_to include(thriller) }
    end
  end

  it "validates that a Genre has a name" do
    genre = Genre.new

    genre.valid?
    expect(genre.errors[:name]).to eq(["can't be blank"])

    genre.name = "Science Fiction"
    genre.valid?
    expect(genre.errors[:name]).to eq([])
  end

  it "validates the uniqueness of the Genre name" do
    comedy = create(:genre, name: "Comedy")
    genre = Genre.new
    genre.name = comedy.name
    genre.valid?
    expect(genre.errors[:name]).to eq(["has already been taken"])
  end
end
