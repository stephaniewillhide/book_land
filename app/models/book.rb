class Book < ApplicationRecord
  has_one_attached :cover

  validates :isbn,
            presence: true,
            uniqueness: true

  validate :length_of_isbn

  validates :name, presence: true

  scope :ordered, -> { order('LOWER(name)') }

  scope :search, -> (search_term) {
    search_term_with_wildcards = "%#{search_term}%"
    where("name LIKE ? OR isbn LIKE ?",
    search_term_with_wildcards, search_term_with_wildcards) }

  scope :featured, -> { where(featured: true) }

  paginates_per 3

  def self.to_csv
    attributes = %w{ name isbn featured }
    CSV.generate do |csv|
      csv << attributes

      all.each do |book|
        csv << book.attributes.values_at(*attributes)
      end
    end
  end

  private def length_of_isbn
    return if isbn.nil?

    if isbn.length != 10 && isbn.length != 13
      errors.add(:isbn, "is the wrong length (should be 10 or 13 characters)")
    end
  end
end
