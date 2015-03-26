class Paper < ActiveRecord::Base
	attr_accessible :name, :document, :user_uid
	require 'carrierwave'
	require 'carrierwave/orm/activerecord'

	belongs_to :user
	mount_uploader :document, DocumentAtUploader
end
