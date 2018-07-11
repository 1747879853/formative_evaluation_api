class Api::V1::UsersController < Api::V1::BaseController
  # Use Knock to make sure the current_user is authenticated before completing request.
  # before_action :authenticate_user_in_production_mode
  # before_action :authorize_as_admin, only: [:destroy]
  # before_action :authorize,          only: [:update]
  
  # Should work if the current_user is authenticated.
  def index
    render json: User.all
  end
  
  # Call this method to check if the user is logged-in.
  # If the user is logged-in we will return the user's information.
  def current
    current_user.update!(last_login: Time.now)
    render json: current_user
  end

  # Method to create a new user using the safe params we setup.
  def create
    unauthorized and return unless Auth.check('Admin/User/create', current_user) || current_user.id == 1

    begin
      user = User.new(user_params)
      if user.save!
        render json: user
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  # Method to update a specific user. User will need to be authorized.
  def update
    unauthorized and return unless Auth.check('Admin/User/update', current_user) || current_user.id.to_s == params[:id]

    begin
      user = User.find(params[:id])
      if user.update(user_params)
        render json: user
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  # Method to delete a user, this method is only for admin accounts.
  def destroy
    unauthorized and return unless Auth.check('Admin/User/destroy', current_user) || current_user.id == 1

    begin
      user = User.find(params[:id])
      if user.destroy
        render json: { }
      end
    rescue Exception => e
      render json: { msg: e }, status: 500      
    end
  end
  
private
  
  # Setting up strict parameters for when we add account creation.
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
  
end
