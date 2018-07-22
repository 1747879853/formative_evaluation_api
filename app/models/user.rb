class User < ApplicationRecord
  has_and_belongs_to_many :auth_groups
  has_many :auth_rules, through: :auth_groups
  has_many :work_shops
  has_many :work_teams
  has_many :work_shop_tasks
  has_many :approval_current_nodes
  has_many :boms_approvals

  # Necessary to authenticate.
  has_secure_password
  
  # Basic password validation, configure to your liking.
  validates_length_of       :password, maximum: 72, minimum: 6, allow_nil: true, allow_blank: false
  validates_confirmation_of :password, allow_nil: true, allow_blank: false

  before_validation { 
    (self.email = self.email.to_s.downcase) && (self.username = self.username.to_s.downcase) 
  }

  # Make sure email and username are present and unique.
  validates_presence_of     :email
  validates_presence_of     :username
  validates_uniqueness_of   :email
  validates_uniqueness_of   :username

  # This method gives us a simple call to check if a user has permission to modify.
  def can_modify_user?(user_id)
    role == 'admin' || id.to_s == user_id.to_s
  end

  # This method tells us if the user is an admin or not.
  def is_admin?
    role == 'admin'
  end

  def as_json(options = {})
    h = super(options)  
    h[:checked_id] = auth_groups.map(&:id)
    h
  end

end
