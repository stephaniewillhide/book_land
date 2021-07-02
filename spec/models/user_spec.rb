require "rails_helper"
require 'database_cleaner/active_record'

DatabaseCleaner.strategy = :truncation

DatabaseCleaner.clean

describe User do

  describe ".ordered" do
    it "orders records by name ASC" do
      beatrice = create(:user, name: "Beatrice")
      adam = create(:user, name: "Adam")
      bernadette = create(:user, name: "bernadette")
      andrea = create(:user, name: "andrea")

      expect(described_class.ordered).to eq([adam, andrea, beatrice, bernadette])
    end
  end

  describe ".search" do
    subject { described_class.search(search_term) }

    let!(:david) { create(:user, name: "David", email: "dsmith@interexchange.org") }
    let!(:candice) { create(:user, name: "Candice", email: "cjones@interexchange.org") }

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
