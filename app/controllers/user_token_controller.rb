class UserTokenController < Knock::AuthTokenController
  skip_before_action :verify_authenticity_token

  def create
  	json = auth_token.as_json
  	h = {
  		"jwt": json["token"],
  		"auth_rules": entity.nil? ? [] : entity.auth_rules.active.select(:name).map(&:name)
  	}
  	render json: h, status: :created
  end
end
