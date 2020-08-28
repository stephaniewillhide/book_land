class CreateGenres < ActiveRecord::Migration[5.2]
  def change
    create_table :genres do |t|
      t.string :name, null: false
      t.timestamps null: false
    end

    add_index :genres, :name, unique: true

    create_table :books_genres, id: false do |t|
      t.belongs_to :book, null: false
      t.belongs_to :genre, null: false
    end
  end
end
