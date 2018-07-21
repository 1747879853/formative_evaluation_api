class UserSerializer < ActiveModel::Serializer
  attributes :id
  attribute :email, key: :name
  attribute :tel, key: :user_tel
  attribute :username, key: :user_name
  attribute :checked_id
  attribute :status
  attribute :operation

  def status
    object.status == "1" ? '在职' : '离职'
  end
  def checked_id
  	object.auth_groups.map(&:id)
  end
  def operation
    'edit,delete'  	
  end
end
