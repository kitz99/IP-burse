class AddUserUidToPaper < ActiveRecord::Migration
  def change
    add_column :papers, :user_uid, :string
  end
end
