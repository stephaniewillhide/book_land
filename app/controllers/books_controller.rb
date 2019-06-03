class BooksController < ApplicationController
  before_action :find_book, only: [:edit, :update, :destroy]

  def index
    @books = Book.ordered.page params[:page]
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(object_params)
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
      redirect_to(books_path, notice: "#{ @book.name } successfully updated.")
    else
      render :edit
    end
  end

  def destroy
    @book.destroy
    redirect_to(books_path, notice: "#{ @book.name } successfully deleted.")
  end

  private def find_book
    @book = Book.find(params[:id])
  end

  private def object_params
    params.require(:book).permit(:name, :isbn)
  end
end
