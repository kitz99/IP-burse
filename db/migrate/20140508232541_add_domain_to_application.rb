class AddDomainToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :domain_id, :integer, :default => 0
  end
end
