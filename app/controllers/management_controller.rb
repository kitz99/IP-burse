class ManagementController < ApplicationController
  def index
  	@current_user = current_user
    @waiting = Array.new
    @accepted = Array.new
    @rejected = Array.new

    Scholarship.all.pluck(:id).each do |id|
      Application.where(:scholarship_id => id).each do |app|
        if app.status == "In asteptare"
          @waiting << app
        end

        if app.status == "Aprobata"
          @accepted << app
        end

        if app.status == "Respinsa"
          @rejected << app
        end
      end
    end

  	@waiting = build_hash @waiting

    @accepted = build_hash @accepted

    @rejected = build_hash @rejected
  end

  protected

  	def build_hash(array)
  		result = Hash.new
  		Scholarship.all.each do |sc|
        aux = array.select { |app|  app.scholarship_id == sc.id  } 
        result[sc.stype] = aux.length
      end

      return result
  	end
end
   