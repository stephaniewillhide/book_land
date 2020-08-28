class Genre < ApplicationRecord
  has_and_belongs_to_many :books

  validates :name,
            presence: true,
            uniqueness: true

  scope :ordered, -> { order('LOWER(genres.name)') }

  scope :search, -> (search_term) do
    search_term_with_wildcards = "%#{search_term}%"
    where("name LIKE ?", search_term_with_wildcards)
  end
end
