class ProcedureNode < ApplicationRecord
  belongs_to :procedure
  belongs_to :owner, polymorphic: true
end
