class WellAlarm < ActiveRecord::Base
	# self.primary_keys = :well_id, :alarm_time	
	self.table_name='alarms'
	belongs_to :well_base, foreign_key: "well_id"


	belongs_to :well_a_last,foreign_key: :well_id

  has_one :well_w_graph,    	
    foreign_key: [:well_id, :record_time],
    primary_key: [:well_id, :record_time]
  has_one :well_wg_std,    	
    foreign_key: :well_id,
    primary_key: :well_id
		# foreign_key: [:well_id, :alarm_time]
		
	scope :popup1, ->(n){ where("record_time > ? and Status=0", Time.now.to_date-n.minutes) }
	scope :popup2, ->(n1, n2){ where("(record_time > ? and StatusB1=0 and Remarks not in ('','未处理','尚未处理')) or (record_time between ? and ? and StatusB1=0)", Time.now.to_date-n1.minutes, Time.now.to_date-n1.minutes, Time.now.to_date-n2.minutes) }
	scope :popup3, ->(n){ where("record_time > ? and Status=0", Time.now.to_date-n.minutes) }
	scope :popup4, ->(n1, n2, n3){ where("(record_time > ? and StatusB2=0 and Remarks not in ('','未处理','尚未处理')) or (record_time between ? and ? and StatusB2=0)", Time.now.to_date-n1.minutes, Time.now.to_date-n2.minutes, Time.now.to_date-n3.minutes) }

	def team_name
		k = [self.well_id, :team_name]
		Rails.cache.write( k, self.well_base.team_name ) unless Rails.cache.exist?( k )
		Rails.cache.fetch( k )
	end

	def htmlid
		self.well_ID + "_" + self.alarm_time.to_i.to_s
	end
 	
	def self.statistic_remark
		adapter = Rails.configuration.database_configuration[Rails.env]["adapter"]
		sql = ""
		case adapter
		when 'postgresql'
			sql = "SELECT COUNT(DISTINCT \"WellAlarm\".\"id\") AS count_id, \"Team\".\"name\", remarks!='' AS team_name_remarks 
			FROM \"WellAlarm\" LEFT OUTER JOIN \"WellBase\" \"well_bases_\"\"WellAlarm\"\"\" 
			ON \"well_bases_\"\"WellAlarm\"\"\".\"well_ID\" = \"WellAlarm\".\"well_ID\" 
			LEFT OUTER JOIN \"Team\" ON \"Team\".\"id\" = \"well_bases_\"\"WellAlarm\"\"\".\"team_id\" 
			INNER JOIN \"WellBase\" ON \"WellAlarm\".\"well_ID\" = \"WellBase\".\"well_ID\" 
			WHERE remarks!='' = true GROUP BY \"Team\".\"name\", remarks!=''"
				# where t.well_base_id 
		when 'oracle_enhanced'
			where("to_number(to_char(well_time,'hh'))=?", n)
		when 'mysql2'
			where("HOUR(`well_time`)=?", n)
		end

		find_by_sql sql 
	end
end
