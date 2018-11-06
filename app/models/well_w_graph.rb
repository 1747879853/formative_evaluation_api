class WellWGraph < ActiveRecord::Base
	self.table_name = 'indicator_diagrams'
	
	self.primary_keys = :well_id, :record_time

	default_scope {order "record_time desc"}

	belongs_to :well_base, foreign_key: "well_id"

	belongs_to :well_hour_q, foreign_key: [:well_id, :record_time]
	belongs_to :electric_power, foreign_key: [:well_id, :record_time]

	# has_one :electric_diagram,
	# 	-> {where("round_time(electric_diagrams.record_time)=round_time(indicator_diagrams.record_time)")},
	# 	foreign_key: "well_id",
	# 	class_name: 'ElectricDiagram'

	# has_one :electric_diagram_last,
	# 	-> {where("round_time(electric_diagram_lasts.record_time)=round_time(indicator_diagrams.record_time)")},
	# 	foreign_key: "well_id",
	# 	class_name: 'ElectricDiagramLast'

	# has_one :electric_diagram_by_hand,
	# 	-> {where("round_time(electric_diagram_by_hands.record_time)=round_time(indicator_diagrams.record_time)")},
	# 	foreign_key: "well_id",
	# 	class_name: 'ElectricDiagramByHand'

  has_one :electric_diagram,
    -> {where("date_trunc('hour', electric_diagrams.record_time)=date_trunc('hour', indicator_diagrams.record_time)")},
    foreign_key: "well_id",
    class_name: 'ElectricDiagram'

  has_one :electric_diagram_last,
    -> {where("date_trunc('hour', electric_diagram_lasts.record_time)=date_trunc('hour', indicator_diagrams.record_time)")},
    foreign_key: "well_id",
    class_name: 'ElectricDiagramLast'

	has_one :electric_diagram_by_hand,
		-> {where("date_trunc('hour', electric_diagram_by_hands.record_time)=date_trunc('hour', indicator_diagrams.record_time)")},
		foreign_key: "well_id",
		class_name: 'ElectricDiagramByHand'

	has_one :well_wg_std, 
		foreign_key: "well_id",
		primary_key: "well_id"

  class << self
	def top_n_per_well_id owner, n
		adapter = Rails.configuration.database_configuration[Rails.env]["adapter"]
		# adapter = ActiveRecord::Base.connection_config[:adapter]
		sql = ""
		ids = if owner.is_a? WellBase
				"'#{owner.Well_ID}'"
				# owner.id
			elsif owner.is_a? Array
				owner.map{|n|"'#{n}'"}.join(',')
			else
				owner.well_bases.map(&:Well_ID).map{|n|"'#{n}'"}.join(',')
				# owner.well_bases.map(&:id).join('')
			end
		case adapter
		when 'postgresql'
			sql = "select * from 
			(select row_number() 
				over (partition by \"well_ID\" 
				order by record_time desc) as r,t.* 
				from \"indicator_diagrams\" t 
				where t.\"well_ID\" 
					in (#{ids})) x 
			where x.r<=#{n} order by t.well_ID, t.record_time desc"
				# where t.well_base_id 
		when 'sqlserver'
			sql = "
				select * from 
					(select row_number() over (
						partition by well_ID order by record_time desc) as r,
					t.* from indicator_diagrams t where t.well_ID in (#{ids})) x 
				where x.r<=#{n}"

		when 'oracle_enhanced'
			where("to_number(to_char(record_time,'hh'))=?", n)
		when 'mysql2'
			where("HOUR(`record_time`)=?", n)
		end

		find_by_sql sql
  	end

	def top_n_per_well_id2 owner, n
		adapter = Rails.configuration.database_configuration[Rails.env]["adapter"]
		# adapter = ActiveRecord::Base.connection_config[:adapter]
		sql = ""
		ids = if owner.is_a? WellBase
				"'#{owner.Well_id}'"
				# owner.id
			elsif owner.is_a? Array
				owner.map{|n|"'#{n}'"}.join(',')
			else
				owner.well_bases.map(&:well_id).map{|n|"'#{n}'"}.join(',')
				# owner.well_bases.map(&:id).join('')
			end
		case adapter
		when 'postgresql'
			sql = "select * from 
			(select row_number() 
				over (partition by \"well_id\" 
				order by record_time desc) as r,t.* 
				from \"indicator_diagrams\" t 
				where t.\"well_id\" 
					in (#{ids})) x 
			where x.r<=#{n} order by well_id, record_time desc"
				# where t.well_base_id 
		when 'sqlserver'
			# select topn.* from WellBase AS wb inner join Team as t on wb.team_id=t.team_id 
			# cross apply ( select top (3) * from WellWGraph as wg where wg.well_ID=wb.well_ID 
			# 	order by well_ID, well_time desc) as topn where t.team_id=1
			# sql = "select a.*, b.comp_status from WellBase AS c 
			# 		cross apply (
			# 			select top (#{n}) * from WellWGraph as o 
			# 			where o.well_ID=c.well_ID 
			# 			order by well_time desc,well_ID) as a 
			# 		inner join WellHourQ as b ON b.well_ID = a.well_ID and b.well_time = a.well_time
			# 	where c.well_ID in (#{ids})"
			sql = "select a.* from WellBase AS c 
					cross apply (
						select top (#{n}) * from indicator_diagrams as o 
						where o.well_ID=c.well_ID 
						order by well_time desc,well_ID) as a 
				where c.well_ID in (#{ids})"

		when 'oracle_enhanced'
			where("to_number(to_char(record_time,'hh'))=?", n)
		when 'mysql2'
			where("HOUR(`record_time`)=?", n)
		end

		find_by_sql sql
  	end

	def top_n_per_well_id_count owner, n
		adapter = Rails.configuration.database_configuration[Rails.env]["adapter"]
		# adapter = ActiveRecord::Base.connection_config[:adapter]
		sql = ""
		ids = if owner.is_a? WellBase
				"'#{owner.Well_ID}'"
				# owner.id
			elsif owner.is_a? Array
				owner.map{|n|"'#{n}'"}.join(',')
			else
				owner.well_bases.map(&:Well_ID).map{|n|"'#{n}'"}.join(',')
				# owner.well_bases.map(&:id).join('')
			end
		case adapter
		when 'postgresql'
			sql = "select * from 
			(select row_number() 
				over (partition by \"well_ID\" 
				order by record_time desc) as r,t.* 
				from \"indicator_diagrams\" t 
				where t.\"well_ID\" 
					in (#{ids})) x 
			where x.r<=#{n} order by t.well_ID, t.record_time desc"
				# where t.well_base_id 
		when 'sqlserver'
			# select topn.* from WellBase AS wb inner join Team as t on wb.team_id=t.team_id 
			# cross apply ( select top (3) * from WellWGraph as wg where wg.well_ID=wb.well_ID 
			# 	order by well_ID, well_time desc) as topn where t.team_id=1
			sql = "select count(a.record_time) as count_top_n from WellBase AS c 
					cross apply (
						select top (#{n}) well_ID, record_time from indicator_diagrams as o 
						where o.well_ID = c.well_ID) as a 
				where c.well_ID in (#{ids})"
			# sql = "SELECT CA.* FROM WellBase V
			# 			       CROSS APPLY (SELECT TOP #{n} *
			# 			                    FROM   WellWGraph CV
			# 			                    WHERE  CV.well_ID = V.well_ID and V.well_ID in (#{ids})
			# 			                    ORDER  BY CV.well_time DESC) CA"  

		when 'oracle_enhanced'
			where("to_number(to_char(record_time,'hh'))=?", n)
		when 'mysql2'
			where("HOUR(`record_time`)=?", n)
		end

		r = find_by_sql sql
		r[0].count_top_n
  	end

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
			sql = "update WellWGraph set calc_status = #{GlobalConstants::WGRAPH_CALC_FINISH_STATUS}
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