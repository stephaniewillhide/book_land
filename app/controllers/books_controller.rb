class BooksController < ApplicationController
  layout "books"
  before_action :find_book, only: [:edit, :update, :destroy, :toggle_featured]

  def index
    @search_term = params.dig(:search, :term)
    @books = Book.ordered
    if @search_term.present?
      @books = @books.search(@search_term)
    end

    respond_to do |format|
      format.html { @books = paginate(@books) }
      format.csv { send_data @books.to_csv, filename: "#{ Date.today.strftime('%Y%m%d')}_books.csv" }
    end
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

  def toggle_featured
    @book.toggle!(:featured)
    redirect_to url_for(action: :index), notice: @book.featured ? "#{ @book.name } successfully featured." : "#{ @book.name } successfully unfeatured."
  end

  def destroy
    @book.destroy
    redirect_to(books_path, notice: "#{ @book.name } successfully deleted.")
  end

  private def find_book
    @book = Book.find(params[:id])
  end

  private def object_params
    params.require(:book).permit(:name, :isbn, :cover, :favorite, :genre)
  end
end
