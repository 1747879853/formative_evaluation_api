class WorkShopSerializer < ActiveModel::Serializer

  attribute :id
  attribute :name
  attribute :dept_type
  # attribute :status
  attribute :user_id
  attribute :status

  # def user_id
  #   User.find(self.user_id).username
  # end


end