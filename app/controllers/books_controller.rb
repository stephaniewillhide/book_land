class BooksController < ApplicationController
  def new
  end

  def create
    @book = Book.new
    if @book.save
      redirect_to(books_path, notice: "#{ @book.name } successfully created.")
    else
      render :new
    end
  end
end
