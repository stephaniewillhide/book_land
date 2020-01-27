class Book < ApplicationRecord
  validates :isbn,
            presence: true,
            uniqueness: true,
            length: { is: 10 || 13 }

  validates :name, presence: true

  scope :ordered, -> { order(name: :asc) }

  # def initialize(params = {})
  #   @params = params
  # end

  # def params
  #   @params
  # end

  # @search_term = params.dig(:search, :term)
  # search_term_with_wildcards = "%#{@search_term}%"

  scope :search, -> (search_term_with_wildcards) { where("name LIKE ? OR isbn LIKE ?", search_term_with_wildcards, search_term_with_wildcards) }

  paginates_per 3
end
