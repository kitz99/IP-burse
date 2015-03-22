class Documents < ActiveRecord::Migration
  def change
  	create_table :documents do |t|
      t.string :name
      # aici am comentat
      t.timestamps null: false
    end
  end
end
