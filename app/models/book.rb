class Book < ApplicationRecord
  has_one_attached :cover

  has_and_belongs_to_many :genre

  validates :isbn,
            presence: true,
            uniqueness: true,
            length: { is: 10 || 13 }

  validates :name, presence: true

  scope :ordered, -> { order(name: :asc) }

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
end
