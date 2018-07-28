class WorkShop < ApplicationRecord
  has_many :work_teams
  has_many :work_shop_tasks
  belongs_to :user

  def as_json(option = {})
  	h = super(option)
  	h[:username] = User.find_by_id(self.user_id).username
  	h
  end


end
