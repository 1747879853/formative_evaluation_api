
class AuthGroupSerializer < ActiveModel::Serializer

  attribute :id
  attribute :title
  attribute :checked_id

  def checked_id
  	object.auth_rules.map(&:id)
  end

end