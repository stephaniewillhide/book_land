class AddPublishedDateToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :published_at, :date
  end
end
