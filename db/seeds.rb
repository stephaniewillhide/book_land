unless User.exists?(email: "admin@example.com")
  User.create!(name: "Admin", email: "admin@example.com", password: "password")
end

unless User.exists?(email: "swillhide@interexchange.org")
  User.create!(name: "Stephanie Willhide", email: "swillhide@interexchange.org", password: "password")
end

unless Book.exists?(isbn: "0393312836")
  Book.create!(name: "A Clockwork Orange", isbn: "0393312836")
end

unless Book.exists?(isbn: "0679734503")
  Book.create!(name: "Crime and Punishment", isbn: "0679734503")
end

unless Book.exists?(isbn: "0679734503")
  Book.create!(name: "Crime and Punishment", isbn: "0679734503")
end

unless Book.exists?(isbn: "0321410971")
  Book.create!(name: "Transcending CSS", isbn: "0321410971")
end

unless Book.exists?(isbn: "0399226907")
  Book.create!(name: "The Very Hungry Caterpillar", isbn: "0399226907")
end
