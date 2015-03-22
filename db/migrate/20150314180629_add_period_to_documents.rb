class AddPeriodToDocuments < ActiveRecord::Migration
  def change
    add_reference :documents, :period, index: true
    add_foreign_key :documents, :periods
    # de ce nu il vad si pe asta?
  end
end
