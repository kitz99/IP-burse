class AddScholarshipToDocuments < ActiveRecord::Migration
  def change
    add_reference :documents, :scholarship, index: true
    add_foreign_key :documents, :scholarships

    # vreau si eu sa ajung pe server
  end
end
