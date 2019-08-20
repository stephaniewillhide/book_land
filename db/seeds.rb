unless User.exists?(email: "admin@example.com")
  User.create!(name: "Admin", email: "admin@example.com", password: "password")
end

unless User.exists?(email: "swillhide@interexchange.org")
  User.create!(name: "Stephanie Willhide", email: "swillhide@interexchange.org", password: "password")
end

[
  ["A Clockwork Orange", "0393312836", "a-clockwork-orange.jpg"],
  ["Crime and Punishment", "0679734503", "crime-and-punishment.jpg"],
  ["Transcending CSS", "0321410971", "transcending-css.jpg"],
  ["The Very Hungry Caterpillar", "0399226907", "the-very-hungry-caterpillar.jpg"]
].each do |name, isbn, filename|
  book = Book.find_or_create_by(name: name, isbn: isbn)
  book.cover.attach(io: File.open(Rails.root.join("db", "sample_data", filename)), filename: filename )
end
