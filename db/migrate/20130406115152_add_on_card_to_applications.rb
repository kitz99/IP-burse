class AddOnCardToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :on_card, :integer
  end
end
