class AuthRuleSerializer < ActiveModel::Serializer
  has_many :children, embed: :ids

  attribute :id
  attribute :name, key: :authority
  attribute :title, key: :name
  attribute :condition
  attribute :status
  attribute :leaf

  def status
    object.status == 1 ? '激活' : '停用'
  end

  def leaf
    object.children.empty? ? 1 : 0
  end

end
