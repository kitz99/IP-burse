class CreateApplications < ActiveRecord::Migration
  def self.up
    create_table :applications do |t|
      
      t.date :submission_date
      t.date :approval_date
      t.string :status
      t.text :reason

      t.timestamps
    end
  end

  def self.down
    drop_table :applications
  end
end
