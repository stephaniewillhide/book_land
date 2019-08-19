class Book < ApplicationRecord
  has_one_attached :cover

  validates :isbn,
            presence: true,
            uniqueness: true,
            length: { is: 10 || 13 }

  validates :name, presence: true

  scope :ordered, -> { order(name: :asc) }

  paginates_per 3
end
