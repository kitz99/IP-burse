class CreateApplicationExtras < ActiveRecord::Migration
  def change
    create_table :application_extras do |t|
      t.decimal :value, :default => 0
      t.references :domain_data, index: true
      t.references :application, index: true

      t.timestamps
    end
  end
end
