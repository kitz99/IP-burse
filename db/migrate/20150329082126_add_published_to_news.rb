class AddPublishedToNews < ActiveRecord::Migration
  def change
    add_column :news, :published, :boolean
  end
end
