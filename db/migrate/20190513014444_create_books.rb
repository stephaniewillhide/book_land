class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :name, null: false
      t.string :isbn, null: false
      t.string :cover
      t.boolean :featured

      t.timestamps
    end
  end
end
