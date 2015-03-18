class Scholarship < ActiveRecord::Base
  attr_accessible :stype, :value

  has_many :application, :foreign_key => "scholarship_id" 
  has_many :domain  
  has_many :document

end
