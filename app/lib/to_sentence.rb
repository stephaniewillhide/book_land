module ArrayToSentence
  def to_sentence_2(words_connector: ", ", last_word_connector: ", and ", two_words_connector: " and ")
    if self.count == 0
      ""
    elsif self.count == 1
      self[0].to_s
    elsif self.count == 2
      self.join(two_words_connector)
    else
      self[0..-2].join(words_connector) + last_word_connector + self[-1].to_s
    end
  end
end
