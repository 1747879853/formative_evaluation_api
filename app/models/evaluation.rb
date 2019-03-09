class Evaluation < ApplicationRecord
  has_and_belongs_to_many :courses

  acts_as_tree

  def as_json(options = {})
	h = super(options)
	h[:title] = self.name
	h[:checked] = false
	h[:expand] = true
	h[:status] = self.status == 1 ? '激活' : '停用'
	h[:in_class] = self.in_class == 1 ? '课内指标' : '课外指标'
	h[:children] = self.status == 1 ? (self.children.where(status:1) if self.children.where(status:1)) : (self.children if self.children)
	h
  end
end