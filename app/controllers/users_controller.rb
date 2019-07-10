class UsersController < ApplicationController
  layout "users"
  before_action :find_user, only: [:edit, :update]

  def index
    @users = User.ordered.page params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(object_params.merge(password: SecureRandom.hex))
    if @user.save
      redirect_to(users_path, notice: "#{ @user.name } successfully created.")
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(object_params)
      redirect_to(users_path, notice: "#{ @user.name } successfully updated.")
    else
      render :edit
    end
  end

  private def find_user
    @user = User.find(params[:id])
  end

  private def object_params
    params.require(:user).permit(:email, :name)
  end
end
