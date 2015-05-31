class ApplicationController < ActionController::Base
  protect_from_forgery

  def login_required
    if !current_user
      respond_to do |format|
        format.html  {
          redirect_to '/auth/autentificare/'
        }
        format.json {
          render :json => { 'error' => 'Access Denied' }.to_json
        }
      end
    end
  end
  

  def current_user
    return nil unless session[:uid]
    @current_user ||= User.find_by_uid(session[:uid])
  end

  def header_prerequisites
    if current_user.is_student == true
      @my_applications = Application.where("user_id = ?", current_user.id)
      @available_appl = Scholarship.find_by_sql("select * from scholarships where id not in ( select scholarship_id from applications where user_id = " + current_user.id.to_s + ")")
    end
  end

end
