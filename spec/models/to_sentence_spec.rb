require "rails_helper"

describe "ToSentence" do
  describe ".to_sentence_2" do
    it "creates a grammatically correct sentence from an array of 0" do
      expect([].to_sentence_2).to eq("")
    end

    it "creates a grammatically correct sentence from an array of 1" do
      expect(["one"].to_sentence_2).to eq("one")
    end

    it "creates a grammatically correct sentence from an array of 2" do
      expect(["one", "two"].to_sentence_2).to eq("one and two")
    end

    it "creates a grammatically correct sentence from an array of 3 or more" do
      expect(["one", "two", "three"].to_sentence_2).to eq("one, two, and three")
    end

    it "creates a grammatically correct sentence from an array of 2 passing through argument" do
      expect(["one", "two"].to_sentence_2(two_words_connector: " or ")).to eq("one or two")
    end

    it "creates a grammatically correct sentence from an array of 3 or more passing through arguments" do
      expect(["one", "two", "three"].to_sentence_2(words_connector: " or ", last_word_connector: " or at least ")).to eq("one or two or at least three")
    end
  end
end
