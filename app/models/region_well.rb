class RegionWell < ApplicationRecord
	belongs_to :region
	belongs_to :well_base
end
