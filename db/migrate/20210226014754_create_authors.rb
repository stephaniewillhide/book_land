class CreateAuthors < ActiveRecord::Migration[5.2]
  def change
    create_table :authors do |t|
      t.string :name
      t.string :biography
      t.string :publisher_name
      t.string :publisher_email
      t.timestamps
    end

    add_index :authors, :name, unique: true

    create_table :authors_books, id: false do |t|
      t.belongs_to :book, null: false
      t.belongs_to :author, null: false
    end
  end
end
