class Api::V1::UsersController < Api::V1::BaseController
  # Use Knock to make sure the current_user is authenticated before completing request.
  # before_action :authenticate_user_in_production_mode
  # before_action :authorize_as_admin, only: [:destroy]
  # before_action :authorize,          only: [:update]
  
  # Should work if the current_user is authenticated.
  def get_userlist
    render json: User.where(status: 1).all
  end
  
  # Call this method to check if the user is logged-in.
  # If the user is logged-in we will return the user's information.
  def current
    current_user.update!(last_login: Time.now)
    render json: current_user
  end

  # Method to create a new user using the safe params we setup.
  def post_userlist
    begin
      user = User.new(user_params)
      user.password='123456'
      if user.save!
        render json: user
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  # Method to update a specific user. User will need to be authorized.
  def patch_userlist

    begin
      user = User.find(params.require(:params)[:id])
      if user.update(params.require(:params).permit(:email, :username, :tel))
        render json: user
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  # Method to delete a user, this method is only for admin accounts.
  def delete_userlist

    begin
      user = User.find(params.require(:params)[:id])
      if user.update(params.require(:params).permit(:status))
        render json: { }
      end
    rescue Exception => e
      render json: { msg: e }, status: 500      
    end
  end
  
private
  
  # Setting up strict parameters for when we add account creation.
  def user_params
    params.require(:params).permit(:username, :email, :tel, :status)
  end
  
end
