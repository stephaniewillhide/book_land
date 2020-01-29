class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private def paginate(collection)
    collection.page(params[:page])
  end
end
