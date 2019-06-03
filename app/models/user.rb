class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  validates :name, presence: true

  scope :ordered, -> { order(name: :asc) }

  paginates_per 3
end
