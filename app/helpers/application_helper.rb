module ApplicationHelper
  def display_cover(book)
    if book.cover.attached?
      book.cover
    else
      "sample-book-cover.jpg"
    end
  end
end
