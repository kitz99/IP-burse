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
