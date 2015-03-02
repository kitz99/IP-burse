class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :title
      t.text :content
      t.timestamp :post_date
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
