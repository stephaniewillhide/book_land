unless User.exists?(email: "admin@example.com")
  User.create!(name: "Admin", email: "admin@example.com", password: "password")
end

unless User.exists?(email: "swillhide@interexchange.org")
  User.create!(name: "Stephanie Willhide", email: "swillhide@interexchange.org", password: "password")
end

[
  ["A Clockwork Orange", "0393312836"],
  ["Crime and Punishment", "0679734503"],
  ["Transcending CSS", "0321410971"],
  ["The Very Hungry Caterpillar", "0399226907"]
].each do |name, isbn|
  Book.find_or_create_by(name: name, isbn: isbn)
end
