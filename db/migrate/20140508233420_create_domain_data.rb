class CreateDomainData < ActiveRecord::Migration
  def self.up
    create_table :domain_data do |t|
      t.string :name
      t.string :sort
      t.references :domain, index: true

      t.timestamps
    end


    for i in 1..46
      DomainData.create :domain_id => i, :name => "Medie", :sort => "desc"
    end
  end
  



  def self.down
   drop_table :domain_data
  end
end
