class Api::V1::UserTokenController < Knock::AuthTokenController
  skip_before_action :verify_authenticity_token

  def create
  	json = auth_token.as_json
  	h = {
  		"jwt": json["token"],
  		"auth_rules": entity.nil? ? [] : entity.auth_rules.active.select(:name).map(&:name),
  		"banzu": WorkTeam.find_by_user_id(json["payload"]["sub"]) ? true : false
  	}
  	render json: h, status: :created
  end
end
