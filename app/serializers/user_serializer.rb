class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :role, :last_login
  attribute :checked_id

  def checked_id
  	object.auth_groups.map(&:id)
  end
end
