class Book < ApplicationRecord
  VALID_ISBN_LENGTHS = [10, 13].freeze

  has_one_attached :cover

  has_and_belongs_to_many :genres

  has_and_belongs_to_many :authors

  validates :isbn,
            presence: true,
            uniqueness: true

  validate :length_of_isbn

  validates :name, presence: true

  validates :published_at, presence: true

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
    LeapYear.new(created_at).leap_year?
  end

  def self.count_in_leap_years
    Book.all.find_all { |book| book.leap_year? }.count
  end

  def self.count_per_year
    book_year_hash = Book.all.group_by { |book| book.created_at.year }
    book_year_hash.transform_values { |books| books.count }
  end

  def self.count_in_years(*years)
    book_year_hash = Book.all.group_by { |book| book.created_at.year }
    count_per_year = book_year_hash.transform_values { |books| books.count }
    count_per_year.default = 0
    years.to_h {|year| [year, count_per_year[year]]}
  end

  def self.per_month(year)
    books_by_year_array = Book.all.find_all { |book| book.created_at.year == year }
    book_month_hash = books_by_year_array.group_by { |book| book.created_at.month }
    count_per_month = book_month_hash.transform_values { |books| books.count }
    count_per_month.default = 0

    count_per_month_default = {}
    (1..12).to_a.each { |month| count_per_month_default[month] = count_per_month[month] }
    count_per_month.each { |month, book_count| count_per_month_default[month] = book_count }
    month_names = Date::MONTHNAMES
    count_per_month_default.transform_keys { |month| month_names[month] }
  end

  private def length_of_isbn
    return if isbn.nil?

    if !VALID_ISBN_LENGTHS.include? isbn.length
      errors.add(:isbn, "is the wrong length (should be #{ VALID_ISBN_LENGTHS.to_sentence(two_words_connector: ' or ') } characters)")
    end
  end
end
