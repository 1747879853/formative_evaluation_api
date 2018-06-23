class AuthRule < ApplicationRecord
  acts_as_tree

  has_and_belongs_to_many :auth_groups
end
