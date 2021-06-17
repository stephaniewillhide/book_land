class Author < ApplicationRecord
  has_and_belongs_to_many :books

  validates :name,
            presence: true,
            uniqueness: true

  validates :biography, presence: true

  validates :publisher_name, presence: true

  validates :publisher_email, presence: true

  validates :date_of_birth, presence: true

  scope :ordered, -> { order('LOWER(authors.name)') }

  scope :search, -> (search_term) do
    search_term_with_wildcards = "%#{search_term}%"
    where("name LIKE ? OR publisher_name LIKE ?", search_term_with_wildcards, search_term_with_wildcards)
  end

  paginates_per 3

  def self.to_csv
    attributes = %w{ name biography publisher_name publisher_email }
    CSV.generate do |csv|
      csv << attributes

      all.each do |author|
        csv << author.attributes.values_at(*attributes)
      end
    end
  end

  def leap_year?
    LeapYear.new(created_at).leap_year?
  end

  def zodiac
    Zodiac.for_date(date_of_birth)
  end

  def age_at_first_release
    date_of_first_book = books.map(&:published_at).min

    average_number_of_days_in_a_year = 365.25
    diff = (date_of_first_book - date_of_birth).to_i / average_number_of_days_in_a_year

    years = diff.floor
    days = (diff.modulo(1) * average_number_of_days_in_a_year).round(0)

    "About #{ years } years and #{ days } days"  end

  def number_of_books_per_genre
    books.flat_map { |book| book.genres }.
      map { |genre| genre.name }.
      group_by { |name| name }.
      transform_values { |names| names.count }
  end

  def bibliography
    author_book_info = books.map do |book|
      humanized_month_name = Date::MONTHNAMES[book.created_at.month]
      genre_names = "(" + book.genres.map { |genre| genre.name }.join(", ") + ")"
      [humanized_month_name, book.created_at.year, book.name, genre_names].join(" ")
    end.join(", ")

    name + ": " + author_book_info
  end
end
