class BookCsvImporter
  def initialize(csv_file_content)
    @csv_file_content = csv_file_content
  end

  def import!
    csv_table = CSV.parse(@csv_file_content, headers: true)

    if csv_table.empty?
      raise "The file is empty"
    end

    expected_csv_headers = ["Name","ISBN","Authors","Genres","Featured","Published At"]
    missing_table_headers = expected_csv_headers - csv_table.headers

    if missing_table_headers.present?
      raise "The headers are incorrect. You are missing #{ missing_table_headers.to_sentence }"
    end

    if csv_table.to_s.match?(/\n,+\n/)
      raise "There is a blank row in the CSV"
    end

    csv_table.each do |row|
      author_names = row["Authors"].split(",")
      authors = author_names.map do |name|
        if (author = Author.find_by(name: name)).present?
          author
        else
          raise "The author name provided does not match any author names in the database"
        end
      end

      genre_names = row["Genres"].split(",")
      genres = genre_names.map do |name|
        if (genre = Genre.find_by(name: name)).present?
          genre
        else
          raise "The genre name provided does not match any genre names in the database"
        end
      end

      isbn = row["ISBN"]
      if (matching_book = Book.find_by(isbn: isbn)).present?
        matching_book.update(
          name: row["Name"],
          isbn: row["ISBN"],
          authors: authors,
          genres: genres,
          featured: row["Featured"],
          published_at: row["Published At"]
        )
      else
        book = Book.create(
          name: row["Name"],
          isbn: row["ISBN"],
          authors: authors,
          genres: genres,
          featured: row["Featured"],
          published_at: row["Published At"]
        )
      end
    end
  end
end
