class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :name
      t.string :path
      t.belongs_to :application
      t.timestamps
    end
  end
end
