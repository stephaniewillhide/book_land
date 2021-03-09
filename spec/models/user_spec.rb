require "rails_helper"

describe User do
  before do
    User.delete_all
  end

  describe ".ordered" do
    it "orders records by name ASC" do
      beatrice = User.create!(name: "Beatrice", email: "beatrice@interexchange.org", password: "password")
      adam = User.create!(name: "Adam", email: "adam@interexchange.org", password: "password")
      bernadette = User.create!(name: "bernadette", email: "bweber@interexchange.org", password: "password")
      andrea = User.create!(name: "andrea", email: "ajackson@interexchange.org", password: "password")

      expect(described_class.ordered).to eq([adam, andrea, beatrice, bernadette])
    end
  end

  describe ".search" do
    subject { described_class.search(search_term) }

    let!(:david) { User.create!(name: "David", email: "dsmith@interexchange.org", password: "password") }
    let!(:candice) { User.create!(name: "Candice", email: "cjones@interexchange.org", password: "password") }

    describe "searching by name" do
      let(:search_term) { "cand" }

      it { is_expected.to include(candice) }
      it { is_expected.not_to include(david) }
    end

    describe "empty search" do
      let(:search_term) { "" }

      it { is_expected.to include(candice) }
      it { is_expected.to include(david) }
    end

    describe "non-matching search" do
      let(:search_term) { "lsk4jfld9skj" }

      it { is_expected.not_to include(candice) }
      it { is_expected.not_to include(david) }
    end

    describe "searching by email" do
      let(:search_term) { "dsmith@interexchange" }

      it { is_expected.not_to include(candice) }
      it { is_expected.to include(david) }
    end
  end
end
