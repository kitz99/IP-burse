class AddScholarshipIdToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :scholarship_id, :integer
  end
end
