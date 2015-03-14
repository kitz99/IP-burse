class Domain < ActiveRecord::Base
  attr_accessible :name, :money, :order_number, :scholarship_id, :period_id, :an_studiu, :procent, :specializare
  belongs_to :scholarship
  has_many :domain_data
  has_many :application

  validates :name, :money, :order_number, :scholarship_id, :period_id, :an_studiu, :procent, :specializare, presence: true
  validates :money, numericality: true
  validates :procent, numericality: { only_integer: true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 100 }
  validates :an_studiu, numericality: { only_integer: true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 4}
end
