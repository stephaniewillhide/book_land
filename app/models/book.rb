class Book < ApplicationRecord

  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  validates :isbn,
            presence: true,
            uniqueness: true,
            length: { is: 10 || 13 }

  validates :name, presence: true

  scope :ordered, -> { order(name: :asc) }
end
