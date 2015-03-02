class AddIbanToUsers < ActiveRecord::Migration
  def change
    add_column :users, :iban, :string
    add_column :users, :bank, :string
  end
end
