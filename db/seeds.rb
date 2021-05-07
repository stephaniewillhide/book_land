unless User.exists?(email: "admin@example.com")
  User.create!(name: "Admin", email: "admin@example.com", password: "password")
end

unless User.exists?(email: "swillhide@interexchange.org")
  User.create!(name: "Stephanie Willhide", email: "swillhide@interexchange.org", password: "password")
end

authors = unless Author.exists?
  FactoryBot.create_list(:author, 5)
end

genres = unless Genre.exists?
  FactoryBot.create_list(:genre, 5)
end

book_covers = [
  "db/sample_data/a-clockwork-orange.jpg",
  "db/sample_data/crime-and-punishment.jpg",
  "db/sample_data/transcending-css.jpg",
  "db/sample_data/the-very-hungry-caterpillar.jpg",
  "db/sample_data/sample-book-cover.jpg"
]

unless Book.exists?
  5.times do
    book = FactoryBot.create(:book, authors: authors.sample(rand(1..2)), genres: genres.sample(rand(1..3)))
    cover = book_covers.sample
    book.cover.attach(
      content_type: "image/jpg",
      filename: cover.split("/").last,
      io: File.open(Rails.root.join(cover)),
    )
  end
end
