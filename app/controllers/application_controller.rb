class ApplicationController < ActionController::API
  # Include Knock within your application.
  include Knock::Authenticable
  
  # skip_before_action :verify_authenticity_token
  # protect_from_forgery
  before_action :authenticate_user

  protected
  
  # Method for checking if current_user is admin or not.
  def authorize_as_admin
    return_unauthorized unless !current_user.nil? && current_user.is_admin?
  end
end
