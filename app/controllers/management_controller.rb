class ManagementController < ApplicationController
  def index
  	@current_user = current_user
  	@waiting = Application.where(:status => "In asteptare").length

    @accepted = Application.where(:status => "Aprobata").length

    @rejected = Application.where(:status => "Respinsa").length
  end
end
