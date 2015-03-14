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
  end

  def show_edit_profile
    @user = current_user
  end

  def edit_profile

    nume = params[:last_name]
    prenume = params[:first_name]
    email = params[:email]
    iban = params[:iban]
    banca = params[:bank]

    user = current_user


    if nume != ""
      user.update_attributes(:last_name => nume)
    end
    if prenume != ""
      user.update_attributes(:first_name => prenume)
    end
    if email != ""
      user.update_attributes(:email => email)
    end
    if iban != ""
      user.update_attributes(:iban => iban)
    end
    if banca != ""
      user.update_attributes(:bank=> banca)
    end

    flash[:notice] = "Datele au fost actualizate"
    redirect_to "/profile"
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



end
