class WellWgLast < ActiveRecord::Base
	self.table_name = 'indicator_diagram_lasts'
	self.primary_keys = :well_id, :record_time

	# default_scope {order "record_time desc, well_id"}

	belongs_to :well_base, foreign_key: "well_id"
	belongs_to :well_hour_q, foreign_key: [:well_ID, :well_time]


  has_one :electric_diagram,
    -> {where("date_trunc('hour', electric_diagrams.record_time)=date_trunc('hour', indicator_diagram_lasts.record_time)")},
    foreign_key: "well_id",
    class_name: 'ElectricDiagram'

  has_one :electric_diagram_last,
    -> {where("date_trunc('hour', electric_diagram_lasts.record_time)=date_trunc('hour', indicator_diagram_lasts.record_time)")},
    foreign_key: "well_id",
    class_name: 'ElectricDiagramLast'

# class Legacy::WellWgLast < Legacy::Base
#   self.table_name = 'WellWGLast'
#   self.primary_keys = :well_ID, :well_time

#   belongs_to :well_base

#   # self.per_page = 1

#   include Spots
# end
  class << self
	def audit_and_calc_finish owner, s, e
		ids = if owner.is_a? WellBase
				"'#{owner.Well_ID}'"
				# owner.id
			elsif owner.is_a? Array
				owner.map{|n|"'#{n}'"}.join(',')
			else
				owner.well_bases.map(&:Well_ID).map{|n|"'#{n}'"}.join(',')
				# owner.well_bases.map(&:id).join('')
			end
		adapter = Rails.configuration.database_configuration[Rails.env]["adapter"]
		# adapter = ActiveRecord::Base.connection_config[:adapter]
		sql = ""
		case adapter
		when 'postgresql'
		when 'sqlserver'
			sql = "update WellWgLast set calc_status = #{GlobalConstants::WGRAPH_CALC_FINISH_STATUS}
					where well_ID in (#{ids}) and well_time between '#{s.strftime("%Y-%m-%d")}' and '#{e.strftime("%Y-%m-%d")}'
					and calc_status = #{GlobalConstants::WGRAPH_CALC_INCLUDED_STATUS}"
		when 'oracle_enhanced'
		when 'mysql2'
		end

		find_by_sql sql
	end
  end

  include Spots
end
