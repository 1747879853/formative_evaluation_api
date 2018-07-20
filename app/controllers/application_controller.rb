class ApplicationController < ActionController::API
  # Include Knock within your application.
  include Knock::Authenticable
  
  # skip_before_action :verify_authenticity_token
  # protect_from_forgery
  before_action :authenticate_user_in_production_mode

  protected

  def authenticate_user_in_production_mode
    authenticate_user unless Rails.env.development?
  end
  
  def unauthorized
    # head :unauthorized
    head :forbidden
  end

  # Method for checking if current_user is admin or not.
  # def authorize_as_admin
  #   unauthorized unless !current_user.nil? && current_user.is_admin?
  # end

  # Adding a method to check if current_user can update itself. 
  # This uses our UserModel method.
  # def authorize
  #   case controller_name
  #   when 'orders'
  #     case action_name
  #     when 'index'
  #       unauthorized unless current_user && Auth.check('Manufacturing/Index/index', current_user)
  #     end
  #   end
  # end

end
