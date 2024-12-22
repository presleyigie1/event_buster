class SessionsController < ApplicationController
  # this controller handles user authentication
  
  def new
    # this action renders the login form
  end

  def create
    # user attempts login
    # securely find the user by username
    user = User.find_by(username: params[:username]) 

    # if the user is found and the password is correct, the user is logged in
    # session is updated with the user's id, and the user is redirected to the root path
    if user&.authenticate(params[:password])
      reset_session # prevent session fixation attacks
      session[:user_id] = user.id
      Rails.logger.info "user #{user.username} logged in successfully at #{Time.current}"
      redirect_to root_path, notice: 'logged in successfully.'
    else
      # if the user is not found or the password is incorrect, an alert message is displayed
      # and the user is rendered the login form again
      Rails.logger.warn "failed login attempt for username: #{params[:username]} at #{Time.current}"
      flash.now[:alert] = 'invalid username or password.'
      render :new
    end
  end

  def destroy
    # this action logs out the current user
    
    # returns:
    # - the user's session is cleared, and the user is redirected to the login path
    if logged_in?
      Rails.logger.info "user #{current_user.username} logged out at #{Time.current}"
    end
    reset_session
    redirect_to login_path, notice: 'logged out successfully.'
  end
end


