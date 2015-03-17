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
  end

  def show_edit_profile
    @user = current_user

    str = "#{CUSTOM_PROVIDER_URL}/students/#{current_user.uid}?oauth_token=#{current_user.token}"

    @info = JSON.parse(open(str).read)

    if ! @info['error'].nil? 
      redirect_to root_url + 'logout'
    end

  end

  def update
    # metoda ce updateasa inline profilul utilizatorului
    # Iau din params ceea ce trebuie sa updatez
    # Verific daca se poate face update-ul si apoi incerc sa scriu in repo
    # TODO:  De vorbit cu cei de la repo sa vada de ce nu se intampla update-ul la user profile

    nume = params['user']['last_name']
    prenume = params['user']['first_name']
    email = params['user']['email']
    iban = params['user']['iban']
    banca = params['user']['bank']
    bi_serie = params['user']['bi_serie']
    bi_numar = params['user']['bi_numar']

    user = current_user
    body = Hash.new
    b = false

    if not nume.nil?
      user.update_attributes(:last_name => nume)
      body["last_name"] = nume
      b = true
    end

    if not prenume.nil?
      user.update_attributes(:first_name => prenume)
      body["first_name"] = prenume
      b = true
    end
    if not email.nil?
      user.update_attributes(:email => email)
      body["email"] = email
      b = true
    end

    if not bi_serie.nil?
      body["bi serie"] = bi_serie
      b = true
    end

    if not bi_numar.nil?
      body["bi numar"] = bi_serie
      b = true
    end

    if not iban.nil?
      if user.update_attributes(:iban => iban)
        body["pass"] = "ok"
      end
    end
    if not banca.nil?
      if user.update_attributes(:bank=> banca)
        body["pass1"] = "ok"
      end
    end

    respond_to do |format|
      if send_info(body, user) == true
        format.html { redirect_to '/profile' }
        format.json { head :no_content }
      elsif (body["pass1"] = "ok" or body["pass"] = "ok") and b == false
        format.html { redirect_to '/profile' }
        format.json { head :no_content }
      else
        format.html { redirect_to "/logout" }
        format.json { head :no_content }
      end
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
  def send_info (b, user) 
    # Metoda care trimite jsonul catre repo pentru update
    # Metoda verifica raspunsul primit si returneaza un mesaj ca atare

    if b.nil?
      return false
    end

    url = "#{CUSTOM_PROVIDER_URL}/update_stud/#{user.uid}?oauth_token=#{user.token}"
    body = b.to_json
    
    response = JSON.parse(RestClient.post url, body, {:content_type => :json})

    # puts "Mesajul de la repo-------------------> #{response}"

    if response['message'] == "error while updating student"
      return false
    end

    return true
  end

end
