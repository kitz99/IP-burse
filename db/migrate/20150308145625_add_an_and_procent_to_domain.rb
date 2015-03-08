class AddAnAndProcentToDomain < ActiveRecord::Migration
  def change
  	add_column :domains, :an_studiu, :integer
  	add_column :domains, :procent, :integer
  	add_column :domains, :specializare, :string
  end
end
