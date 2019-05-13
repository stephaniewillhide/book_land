class Book < ApplicationRecord
  validates :isbn,
            uniqueness: true,
            length: { is: 10 || 13 }
end
