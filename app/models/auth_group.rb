class AuthGroup < ApplicationRecord
  has_and_belongs_to_many :auth_rules
  has_and_belongs_to_many :users

  validates_presence_of     :title
  validates_uniqueness_of   :title

  def as_json(options = {})
		h = {}	
		h[:id] = self.id
		h[:title] = self.title
		h[:checked_id] = auth_rules.map(&:id)
		h[:checked] = false
		h
	end
end
