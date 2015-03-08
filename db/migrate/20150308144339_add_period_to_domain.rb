class AddPeriodToDomain < ActiveRecord::Migration
  def change
    add_reference :domains, :period, index: true
    add_foreign_key :domains, :periods
  end
end
