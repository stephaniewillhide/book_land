module ApplicationHelper
  def display_cover(book)
    if :cover.present?
      render :cover
    else
      "sample-book-cover.jpg"
    end
  end
end
