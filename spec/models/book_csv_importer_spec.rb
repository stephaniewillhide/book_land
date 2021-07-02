require "rails_helper"
require "rails_helper"
require 'database_cleaner/active_record'

DatabaseCleaner.strategy = :truncation

DatabaseCleaner.clean

describe BookCsvImporter do

  describe "#import!" do
    let(:importer) { described_class.new(csv_file_content) }

    let(:csv_file_content) do
      <<~CSV
        Name,ISBN,Authors,Genres,Featured,Published At
        name_value,isbn_value,author1,genre1,true,2021-06-22
      CSV
    end

    context "successfully importing Books from a CSV" do
      it "imports the Books into the database" do
        create(:author, name: "author1")
        create(:genre, name: "genre1")
        importer.import!

        book = Book.first

        expect(book.name).to eq("name_value")
        expect(book.isbn).to eq("isbn_value")
        expect(book.authors.first.name).to eq("author1")
        expect(book.genres.first.name).to eq("genre1")
        expect(book.featured).to eq(true)
        expect(book.published_at).to eq(Date.parse("Tue, 22 Jun 2021"))
      end
    end

    context "The ISBN already exists and data must be updated" do
      let!(:existing_book) { create(:book, isbn: "isbn_value") }
      let(:csv_file_content) do
        <<~CSV
          Name,ISBN,Authors,Genres,Featured,Published At
          name_value,isbn_value,author1,genre1,true,2021-06-22
        CSV
      end

      it "imports the Books into the database" do
        create(:author, name: "author1")
        create(:genre, name: "genre1")
        importer.import!

        existing_book.reload
        expect(existing_book.name).to eq("name_value")
        expect(existing_book.isbn).to eq("isbn_value")
        expect(existing_book.authors.first.name).to eq("author1")
        expect(existing_book.genres.first.name).to eq("genre1")
        expect(existing_book.featured).to eq(true)
        expect(existing_book.published_at).to eq(Date.parse("Tue, 22 Jun 2021"))
      end
    end

    context "Author doesn't exist" do
      it "imports the Books into the database" do
        create(:genre, name: "genre1")
        expect { importer.import! }.to raise_error("The author name provided does not match any author names in the database")
      end
    end

    context "Genre doesn't exist" do
      it "imports the Books into the database" do
        create(:author, name: "author1")
        expect { importer.import! }.to raise_error("The genre name provided does not match any genre names in the database")
      end
    end

    context "Headers are incorrect" do
      let(:csv_file_content) do
        <<~CSV
          Namex,ISBNx,Authorsx,Genresx,Featuredx,Published At
          name_value,isbn_value,author1,genre1,true,2021-06-22
        CSV
      end

      it "imports the Books into the database" do
        create(:author, name: "author1")
        create(:genre, name: "genre1")
        expect { importer.import! }.to raise_error("The headers are incorrect. You are missing Name, ISBN, Authors, Genres, and Featured")
      end
    end

    context "A blank row has been added" do
      let(:csv_file_content) do
        <<~CSV
          Name,ISBN,Authors,Genres,Featured,Published At

          name_value,isbn_value,author1,genre1,true,2021-06-22
        CSV
      end

      it "imports the Books into the database" do
        create(:author, name: "author1")
        create(:genre, name: "genre1")
        expect { importer.import! }.to raise_error("There is a blank row in the CSV")
      end
    end

    context "The file is empty" do
      let(:csv_file_content) do
        <<~CSV
        CSV
      end

      it "imports the Books into the database" do
        expect { importer.import! }.to raise_error("The file is empty")
      end
    end
  end
end
