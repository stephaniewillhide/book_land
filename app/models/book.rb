class Book < ApplicationRecord
  validates :isbn,
            presence: true,
            uniqueness: true,
            length: { is: 10 || 13 }

  validates :name, presence: true
end
