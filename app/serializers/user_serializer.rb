class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :role, :last_login
end
