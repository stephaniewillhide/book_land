class AddDateOfBirthToAuthors < ActiveRecord::Migration[5.2]
  def change
    add_column :authors, :date_of_birth, :date
  end
end
