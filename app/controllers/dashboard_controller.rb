class DashboardController < ApplicationController
  layout "books"

  def index
    @books = Book.ordered.featured
  end

end
