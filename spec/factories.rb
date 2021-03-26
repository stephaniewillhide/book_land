FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { "#{name.parameterize.underscore}@example.com" }
    password { "password" }
  end

  factory :book do
    name { Faker::Book.title }
    isbn do
      Book::VALID_ISBN_LENGTHS.sample.times.map { rand(10) }.join
    end
    cover { nil }
    featured { [true, false].sample }
    transient do
      number_of_authors { 1 }
      number_of_genres { 1 }
    end
    authors { create_list(:author, number_of_authors) }
    genres { create_list(:genre, number_of_genres) }
  end

  factory :author do
    name { Faker::Book.author }
    biography { Faker::TvShows::TheFreshPrinceOfBelAir.quote }
    publisher_name { Faker::Book.publisher }
    publisher_email { Faker::Internet.email }
  end

  factory :genre do
    name { Faker::Book.genre }
  end
end
