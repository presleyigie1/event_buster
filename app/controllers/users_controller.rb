class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    # securely initialize a new user with strong parameters
    @user = User.new(user_params)

    # handle role assignment securely
    # if the role is admin, check for a valid admin code
    if params[:user][:role] == 'admin'
      if params[:user][:admin_code] == '3021'
        @user.role = 'admin' # assign admin role only if admin code is correct
      else
        Rails.logger.warn "invalid admin code attempt for username: #{params[:user][:username]}"
        flash.now[:alert] = 'invalid admin code.'
        render :new
        return
      end
    else
      @user.role = 'user' # assign default role as 'user'
    end

    # if the user is saved successfully, log them in and redirect
    if @user.save
      Rails.logger.info "new user #{user_params[:username]} created successfully as #{@user.role} at #{Time.current}"
      reset_session # prevent session fixation attacks
      session[:user_id] = @user.id # auto log the user in after sign-up
      redirect_to root_path, notice: 'account created successfully!'
    else
      # if there are errors during save, show the form again with an error message
      Rails.logger.error "user creation failed for #{user_params[:username]} at #{Time.current}"
      flash.now[:alert] = 'error creating account. please check the form.'
      render :new
    end
  end

  private

  # strong parameters to whitelist user inputs
  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end

