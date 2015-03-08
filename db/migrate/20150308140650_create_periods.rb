class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.date :start
      t.date :end
      t.integer :buget
      t.boolean :activ
      t.integer :nr_stud
      t.integer :min_salary

      t.timestamps null: false
    end
  end
end
