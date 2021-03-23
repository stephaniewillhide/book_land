unless User.exists?(email: "admin@example.com")
  User.create!(name: "Admin", email: "admin@example.com", password: "password")
end

unless User.exists?(email: "swillhide@interexchange.org")
  User.create!(name: "Stephanie Willhide", email: "swillhide@interexchange.org", password: "password")
end

genres = [
  "Dystopian Fiction",
  "Psychological Fiction",
  "Reference",
  "Children's Literature",
  "Russian Literature"
].map do |name|
  Genre.find_or_create_by(name: name)
end

[
  ["A Clockwork Orange", "0393312836", "db/sample_data/a-clockwork-orange.jpg", ["Dystopian Fiction"]],
  ["Crime and Punishment", "0679734503", "db/sample_data/crime-and-punishment.jpg", ["Psychological Fiction", "Russian Literature"]],
  ["Transcending CSS", "0321410971", "db/sample_data/transcending-css.jpg"],
  ["The Very Hungry Caterpillar", "0399226907", "db/sample_data/the-very-hungry-caterpillar.jpg", ["Children's Literature"]]
].each do |name, isbn, cover, genre_names = []|
  book = Book.find_or_create_by(name: name, isbn: isbn)
  matching_genres = genres.select { |genre| genre_names.include?(genre.name) }
  book.update(genres: matching_genres)
  unless book.cover.attached?
    book.cover.attach(
      content_type: "image/jpg",
      filename: cover.split("/").last,
      io: File.open(Rails.root.join(cover)),
    )
  end
end

