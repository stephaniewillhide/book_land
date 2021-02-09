require "rails_helper"

describe User do
  before do
    User.delete_all
  end

  describe ".ordered" do
    it "orders records by name ASC" do
      beatrice = User.create!(name: "Beatrice", email: "beatrice@interexchange.org", password: "password")
      adam = User.create!(name: "Adam", email: "adam@interexchange.org", password: "password")

      expect(described_class.ordered).to eq([adam, beatrice])
    end
  end

  describe ".search" do
    subject { described_class.search(search_term) }

    let!(:david) { User.create!(name: "David", email: "david@interexchange.org", password: "password") }
    let!(:candice) { User.create!(name: "Candice", email: "candice@interexchange.org", password: "password") }

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
      let(:search_term) { "david@interexchange" }

      it { is_expected.not_to include(candice) }
      it { is_expected.to include(david) }
    end
  end
end
