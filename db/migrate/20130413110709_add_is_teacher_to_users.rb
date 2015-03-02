class AddIsTeacherToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_teacher, :boolean
  end
end
