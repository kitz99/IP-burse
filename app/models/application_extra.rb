class ApplicationExtra < ActiveRecord::Base
  belongs_to :domain_data
  belongs_to :application
  attr_accessible :value, :application_id, :domain_data_id
end
