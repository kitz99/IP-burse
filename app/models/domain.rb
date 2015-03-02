class Domain < ActiveRecord::Base
  attr_accessible :name, :money, :order_number, :scholarship_id
  belongs_to :scholarship
  has_many :domain_data
  has_many :application
end
