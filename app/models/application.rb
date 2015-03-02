class Application < ActiveRecord::Base
  attr_accessible :approval_date, :reason, :status, :submission_date, :scholarship_id, :user_id, :on_card

  belongs_to :scholarship
  belongs_to :domain
  belongs_to :user
  
  has_many :application_extra
  has_many :attachments
  accepts_nested_attributes_for :attachments

end
