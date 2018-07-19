class Procedure < ApplicationRecord
  belongs_to :approval
  has_many :procedure_nodes
end
