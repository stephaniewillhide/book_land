class BooksController < ApplicationController
  def new
  end

  def create
    def create
      render plain: params[:book].inspect
    end
  end

  def index
    @books = Book.all
  end
end
