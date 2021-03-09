class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  validates :name, presence: true

  scope :ordered, -> { order('LOWER(users.name)') }

  scope :search, -> (search_term) {
    search_term_with_wildcards = "%#{search_term}%"
    where("name LIKE ? OR email LIKE ?",
    search_term_with_wildcards, search_term_with_wildcards) }

  paginates_per 3
end
