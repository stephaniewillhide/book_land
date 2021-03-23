class GenresController < ApplicationController
  layout "genres"
  before_action :find_genre, only: [:edit, :update, :destroy]

  def index
    @search_term = params.dig(:search, :term)
    @genres = Genre.ordered
    if @search_term.present?
      @genres = @genres.search(@search_term)
    end
  end

  def new
    @genre = Genre.new
  end

  def create
    @genre = Genre.new(object_params)
    if @genre.save
      redirect_to(genres_path, notice: "#{ @genre.name } successfully created.")
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @genre.update(object_params)
      redirect_to(genres_path, notice: "#{ @genre.name } successfully updated.")
    else
      render :edit
    end
  end

  def destroy
    @genre.destroy
    redirect_to(genres_path, notice: "#{ @genre.name } successfully deleted.")
  end

  private def find_genre
    @genre = Genre.find(params[:id])
  end

  private def object_params
    params.require(:genre).permit(:name)
  end
end
