class Approval < ApplicationRecord
  has_many :approval_fields
  has_many :approval_detail_fields
  has_many :procedures
end
