class WorkLog < ApplicationRecord
 	belongs_to :owner, polymorphic: true
end
