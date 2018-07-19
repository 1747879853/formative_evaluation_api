class WorkShop < ApplicationRecord
  has_many :work_teams
  belongs_to :user


  def as_json(options = {})
  	h = super(options)
  	h[:username] = User.find(self.user_id).username
  	h
  end
end
