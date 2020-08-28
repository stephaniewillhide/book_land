unless User.exists?(email: "admin@example.com")
  User.create!(name: "Admin", email: "admin@example.com", password: "password")
end

unless User.exists?(email: "swillhide@interexchange.org")
  User.create!(name: "Stephanie Willhide", email: "swillhide@interexchange.org", password: "password")
end

[
  ["A Clockwork Orange", "0393312836", "db/sample_data/a-clockwork-orange.jpg, Dystopian Fiction"],
  ["Crime and Punishment", "0679734503", "db/sample_data/crime-and-punishment.jpg, Psychological Fiction"],
  ["Transcending CSS", "0321410971", "db/sample_data/transcending-css.jpg, Reference"],
  ["The Very Hungry Caterpillar", "0399226907", "db/sample_data/the-very-hungry-caterpillar.jpg, Children's Literature"]
].each do |name, isbn, cover, genre|
  book = Book.find_or_create_by(name: name, isbn: isbn)
  unless book.cover.attached?
    book.cover.attach(
      content_type: "image/jpg",
      filename: cover.split("/").last,
      io: File.open(Rails.root.join(cover)),
    )
  end
end
