unless User.exists?(email: "admin@example.com")
  User.create!(name: "Admin", email: "admin@example.com", password: "password")
end

unless User.exists?(email: "swillhide@interexchange.org")
  User.create!(name: "Stephanie Willhide", email: "swillhide@interexchange.org", password: "password")
end

[
  ["A Clockwork Orange", "0393312836", "/db/sample_data/a-clockwork-orange.jpg"],
  ["Crime and Punishment", "0679734503", "/db/sample_data/crime-and-punishment.jpg"],
  ["Transcending CSS", "0321410971", "/db/sample_data/transcending-css.jpg"],
  ["The Very Hungry Caterpillar", "0399226907", "/db/sample_data/the-very-hungry-caterpillar.jpg"]
].each do |name, isbn|
  Book.find_or_create_by(name: name, isbn: isbn, cover: cover)
end
