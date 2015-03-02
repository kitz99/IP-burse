class AddResponseToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :response, :text
  end
end
