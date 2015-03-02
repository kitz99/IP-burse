class DomainData < ActiveRecord::Base
  attr_accessible :name, :sort, :domain_id
  belongs_to :domain
end
