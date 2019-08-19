unless User.exists?(email: "admin@example.com")
  User.create!(name: "Admin", email: "admin@example.com", password: "password")
end

unless User.exists?(email: "swillhide@interexchange.org")
  User.create!(name: "Stephanie Willhide", email: "swillhide@interexchange.org", password: "password")
end

unless Book.exists?(isbn: "0393312836")
  Book.create!(name: "A Clockwork Orange", isbn: "0393312836", cover: "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDQT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--f3423da555b11e869633eb115d452244d493d177/a-clockwork-orange.jpg")
end

unless Book.exists?(isbn: "0679734503")
  Book.create!(name: "Crime and Punishment", isbn: "0679734503", cover: "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--a25d19cf492a9b7618242ba0f708a874342891d2/crime-and-punshment.jpg")
end

unless Book.exists?(isbn: "0321410971")
  Book.create!(name: "Transcending CSS", isbn: "0321410971", cover: "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--3e5c4d8aa5be3bca60007525780b0fca9a2c9074/transcending-css.jpg")
end

unless Book.exists?(isbn: "0399226907")
  Book.create!(name: "The Very Hungry Caterpillar", isbn: "0399226907", cover: "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--fa4a8930e8bc21c2b687ed387291dd05b588ee91/the-very-hungry-caterpillar.jpg")
end
