class BooksController < ApplicationController

  def index
    @books = Book.ordered
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new
    if @book.save
      redirect_to(books_path, notice: "#{ @book.name } successfully created.")
    else
      render :new
    end
  end

  def edit
  end
end
