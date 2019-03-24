unless User.exists?(email: "admin@example.com")
  User.create!(name: "Admin", email: "admin@example.com", password: "password")
end
