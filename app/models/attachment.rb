class Attachment < ActiveRecord::Base
   mount_uploader :path, DocumentUploader
   attr_accessible :application_id,:name,:path

   belongs_to :application
end
