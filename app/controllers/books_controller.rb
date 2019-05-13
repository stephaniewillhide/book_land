class BooksController < ApplicationController
  before_action :find_book, only: [:edit, :update]

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

  def update
    if @book.update(object_params)
      redirect_to(bookss_path, notice: "#{ @book.name } successfully updated.")
    else
      render :edit
    end
  end

  private def object_params
    params.require(:book).permit(:name, :isbn)
  end
end
