unless User.exists?(email: "admin@example.com")
  User.create!(name: "Admin", email: "admin@example.com", password: "password")
end

unless User.exists?(email: "swillhide@interexchange.org")
  User.create!(name: "Stephanie Willhide", email: "swillhide@interexchange.org", password: "password")
end

authors = [
  ["Anthony Burgess", "Anthony Burgess was an English writer and composer.", "W. W. Norton & Company", "info@wwnorton.com"],
  ["Fyodor Dostoevsky", "Fyodor Mikhailovich Dostoevsky was a Russian novelist, philosopher, short story writer, essayist, and journalist.", "Vintage Classics", "info@classics.com"],
  ["Andy Clarke", "Andy Clarke is an accomplished website designer who believes in the power of ideas.", "New Riders Pub", "andy@newriders.com"],
  ["Molly E. Holzschlag", "Molly E. Holzschlag is a U.S. author, lecturer and advocate of the Open Web.", "New Riders Pub", "molly@newriders.com"],
  ["Eric Carle", "Eric Carle is an American designer, illustrator, and writer of children's books.", "Philomel Books", "info@pb.com"]
].map do |name, biography, publisher_name, publisher_email|
  Author.find_or_create_by(
    name: name,
    biography: biography,
    publisher_name: publisher_name,
    publisher_email: publisher_email
  )
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
  ["A Clockwork Orange", "0393312836", "db/sample_data/a-clockwork-orange.jpg", ["Anthony Burgess"], ["Dystopian Fiction"]],
  ["Crime and Punishment", "0679734503", "db/sample_data/crime-and-punishment.jpg", ["Fyodor Dostoevsky"], ["Psychological Fiction", "Russian Literature"]],
  ["Transcending CSS", "0321410971", "db/sample_data/transcending-css.jpg", ["Andy Clarke", "Molly E. Holzschlag"],[]],
  ["The Very Hungry Caterpillar", "0399226907", "db/sample_data/the-very-hungry-caterpillar.jpg", ["Eric Carle"], ["Children's Literature"]]
].each do |name, isbn, cover, author_names = [], genre_names = []|
  book = Book.find_or_create_by(name: name, isbn: isbn)
  matching_authors = authors.select { |author| author_names.include?(author.name) }
  book.update(authors: matching_authors)
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
