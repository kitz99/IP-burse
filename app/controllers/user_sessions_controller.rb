class UserSessionsController < ApplicationController
  before_filter :login_required, :only => [ :destroy ]

  respond_to :html

  def create
    omniauth = env['omniauth.auth']

    user = User.find_by_uid(omniauth['uid'])
    if not user
      if omniauth['extra']['student'] == 'true'
        session[:first_auth] = true
      end

      user = User.new(:uid => omniauth['uid'])
    else
      session[:first_auth] = false
    end    
    
    user.first_name = omniauth['extra']['first_name']
    user.last_name  = omniauth['extra']['last_name']
    user.email  = omniauth['extra']['email']
    user.is_student  = omniauth['extra']['student']
    user.is_teacher  = omniauth['extra']['teacher']
    user.is_management  = omniauth['extra']['management']
    user.is_admin  = omniauth['extra']['admin']
    user.token = omniauth['credentials']['token']
    user.save


    session[:uid] = omniauth['uid']

    flash[:notice] = "Successfully logged in"
    redirect_to root_path
  end

  def show_profile
    @user = current_user
    str = "#{CUSTOM_PROVIDER_URL}/students/#{current_user.uid}?oauth_token=#{current_user.token}"

    @info = JSON.parse(open(str).read)

    if ! @info['error'].nil? 
      redirect_to root_url + 'logout'
    end
    # @info = YAML::dump(@info)
  end

  def show_edit_profile
    @user = current_user

    str = "#{CUSTOM_PROVIDER_URL}/students/#{current_user.uid}?oauth_token=#{current_user.token}"

    @info = JSON.parse(open(str).read)

    if ! @info['error'].nil? 
      redirect_to root_url + 'logout'
    end

  end

  def edit_profile

    nume = params[:last_name]
    prenume = params[:first_name]
    email = params[:email]
    iban = params[:iban]
    banca = params[:bank]
    bi_serie = params[:bi_serie]
    bi_numar = params[:bi_numar]

    user = current_user
    body = Hash.new()

    if nume != ""
      user.update_attributes(:last_name => nume)
      body["last_name"] = nume
    end
    if prenume != ""
      user.update_attributes(:first_name => prenume)
      body["first_name"] = prenume
    end
    if email != ""
      user.update_attributes(:email => email)
      body["email"] = email
    end

    if bi_serie != ""
      body["bi serie"] = bi_serie
    end

    if bi_numar != ""
      body["bi numar"] = bi_serie
    end

    if iban != ""
      user.update_attributes(:iban => iban)
    end
    if banca != ""
      user.update_attributes(:bank=> banca)
    end

    url = "#{CUSTOM_PROVIDER_URL}/update_stud/#{@current_user.uid}?oauth_token=#{@current_user.token}"
    body = body.to_json

    puts "-------------------------------------------------------> #{body}"
    
    response = RestClient.post url, body, {:content_type => :json} 


    response = JSON.parse(response)

    if response['message'] == "error while updating student"
      flash[:error] = "Error while updating your profile"
      redirect_to "/profile"

    else
      flash[:notice] = "Datele au fost actualizate"
      redirect_to "/profile"
    end

  end

  # Omniauth failure callback
  def failure
    flash[:notice] = params[:message]
  end


  def destroy
    reset_session
    flash[:notice] = 'You have successfully signed out!'
    redirect_to "#{CUSTOM_PROVIDER_URL}/users/sign_out"
  end

private
    def send_info (b) 
    url = "#{CUSTOM_PROVIDER_URL}/update_stud/#{@current_user.uid}?oauth_token=#{@current_user.token}"
    body = b.to_json
    
    response = RestClient.post url, body, {:content_type => :json} 


    response = JSON.parse(response)

    if response['message'] == "error while updating student"
      return false
    end

    return true
  end

end
