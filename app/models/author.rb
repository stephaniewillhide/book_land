class Author < ApplicationRecord
  has_and_belongs_to_many :books

  validates :name,
            presence: true,
            uniqueness: true

  validates :biography, presence: true

  validates :publisher_name, presence: true

  validates :publisher_email, presence: true

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
end
