class Document < ActiveRecord::Base
	belongs_to :scholarship
	belongs_to :period
end
