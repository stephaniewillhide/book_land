class AuthorsController < ApplicationController
  before_action :find_author, only: [:edit, :update, :destroy]

  def index
    @search_term = params.dig(:search, :term)
    @authors = Author.ordered
    if @search_term.present?
      @authors = @authors.search(@search_term)
    end

    respond_to do |format|
      format.html { @authors = paginate(@authors) }
      format.csv { send_data @authors.to_csv, filename: "#{ Date.today.strftime('%Y%m%d')}_authors.csv" }
    end
  end

  def new
    @author = Author.new
  end

  def create
    @author = Author.new(object_params)
    if @author.save
      redirect_to(authors_path, notice: "#{ @author.name } successfully created.")
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @author.update(object_params)
      redirect_to(authors_path, notice: "#{ @author.name } successfully updated.")
    else
      render :edit
    end
  end

  def destroy
    @author.destroy
    redirect_to(authors_path, notice: "#{ @author.name } successfully deleted.")
  end

  private def find_author
    @author = Author.find(params[:id])
  end

  private def object_params
    params.require(:author).permit(:name, :biography, :publisher_name, :publisher_email)
  end
end
