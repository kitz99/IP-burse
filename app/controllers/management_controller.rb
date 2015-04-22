class ManagementController < ApplicationController
  before_filter :login_required, :header_prerequisites


  def index
    if !current_user.is_management
      redirect_to("/logout")
    end
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

  def render_table
    if !current_user.is_management
      redirect_to("/logout")
    end
    sw = build_status params[:sw]
    stype = params[:stype]

    s_id = Scholarship.find_by(:stype => stype)

    @applications = build_app_hash_array Application.where(:status => sw, :scholarship_id => s_id)
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

    def build_status(string)
      if string == "waiting"
        return "In asteptare"
      elsif string == "accepted"
        return "Aprobata"
      elsif string == "rejected"
        return "Respinsa"
      else
        redirect_to "/logout"

      end
    end

    def build_app_hash_array(array)
      result = Array.new
      array.each do |elem|
        student = User.find_by(:id => elem.user_id)
        result << {
          :student_first => student.first_name,
          :student_last => student.last_name,
          :app => elem
        }
      end
      return result
    end
end
   