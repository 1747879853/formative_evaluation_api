class AuthRule < ApplicationRecord
  has_and_belongs_to_many :auth_groups
  has_many :users, through: :auth_groups

  acts_as_tree

  validates_presence_of     :name
  validates_presence_of     :title
  validates_uniqueness_of   :name
  validates_uniqueness_of   :title

end
