class Book < ApplicationRecord
  has_one_attached :cover

  has_and_belongs_to_many :genres

  validates :isbn,
            presence: true,
            uniqueness: true

  validate :length_of_isbn

  validates :name, presence: true

  scope :ordered, -> { order('LOWER(books.name)') }

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

  def leap_year?
    year = created_at.year

    divisible_by_4 = year % 4 == 0
    not_divisible_by_100 = year % 100 != 0
    divisible_by_400 = year % 400 == 0

    (divisible_by_4 && not_divisible_by_100) || divisible_by_400
  end

  private def length_of_isbn
    return if isbn.nil?

    if isbn.length != 10 && isbn.length != 13
      errors.add(:isbn, "is the wrong length (should be 10 or 13 characters)")
    end
  end
end
