unless User.exists?(email: "admin@example.com")
  User.create!(name: "Admin", email: "admin@example.com", password: "password")
end

unless User.exists?(email: "swillhide@interexchange.org")
  User.create!(name: "Stephanie Willhide", email: "swillhide@interexchange.org", password: "password")
end
