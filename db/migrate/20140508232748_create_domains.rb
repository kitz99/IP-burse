class CreateDomains < ActiveRecord::Migration
  def self.up
    create_table :domains do |t|
      t.string :name
      t.decimal :money
      t.integer :order_number
      t.references :scholarship, index: true

      t.timestamps
    end
  end


  def self.down
   drop_table :domains
  end
end
