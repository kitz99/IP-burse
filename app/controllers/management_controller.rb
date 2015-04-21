class ManagementController < ApplicationController
  def index
  	@current_user = current_user
  	@waiting = build_hash Application.where(:status => "In asteptare").group(:scholarship_id)

    @accepted = Application.where(:status => "Aprobata").length

    @rejected = Application.where(:status => "Respinsa").length
  end

  protected

  	def build_hash(array)
  		result = Hash.new
  		sc_name = Scholarship.find_by(:id => array.first.scholarship_id).stype
  		number = array.length
  		{:sc_name => sc_name, :number => number}
  	end
end
   