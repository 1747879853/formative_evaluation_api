class AuthGroup < ApplicationRecord
  has_and_belongs_to_many :auth_rules
  has_and_belongs_to_many :users

  validates_presence_of     :title
  validates_uniqueness_of   :title

end
