class WellBase < ActiveRecord::Base
  self.primary_key = "well_id"
  
  # default_scope { where(show_status: 1).order(:well_id) }
  # default_scope { where(show_status: 1) }

  scope :visible, -> { where(show_status: 1) }
  scope :pump, -> { where(show_status: 1).where(well_type_id: 2) }
  scope :screw, -> { where(show_status: 1).where(well_type_id: 3) }

  belongs_to :team

  has_many :oil_pressures,
      foreign_key: "well_id",
      primary_key: "well_id"
  has_many :oil_pressure_lasts,
      foreign_key: "well_id",
      primary_key: "well_id"

  has_many :casing_pressures,
      foreign_key: "well_id",
      primary_key: "well_id"
  has_many :casing_pressure_lasts,
      foreign_key: "well_id",
      primary_key: "well_id"

  has_many :electric_parameters,
      foreign_key: "well_id",
      primary_key: "well_id"
  has_many :electric_parameter_lasts,
      foreign_key: "well_id",
      primary_key: "well_id"

  has_many :screw_electric_parameters,
      class_name: 'ElectricParameter',
      foreign_key: "well_id",
      primary_key: "well_id"
  has_many :screw_electric_parameter_lasts,
      class_name: 'ElectricParameterLast',
      foreign_key: "well_id",
      primary_key: "well_id"

  has_many :electric_pump_bases,
      foreign_key: "well_id",
      primary_key: "well_id"
  has_many :electric_pump_base_lasts,
      foreign_key: "well_id",
      primary_key: "well_id"

# 下面两个是为新的电泵井传感器用的
  has_many :electric_pump_base_new,
      foreign_key: "well_id",
      primary_key: "well_id"
  has_many :electric_pump_base_last_new,
      foreign_key: "well_id",
      primary_key: "well_id"

  has_many :screw_pump_bases,
      foreign_key: "well_id",
      primary_key: "well_id"
  has_many :screw_pump_base_lasts,
      foreign_key: "well_id",
      primary_key: "well_id"


  has_many :well_w_graph,
      foreign_key: "well_id",
      primary_key: "well_id"

  has_many :well_w_graph_by_hand,
      foreign_key: "well_id",
      primary_key: "well_id"

  has_many :electric_diagrams,
      foreign_key: "well_id",
      primary_key: "well_id"

  has_many :electric_diagram_lasts, 
    foreign_key: "well_id",
    primary_key: "well_id"

  has_many :electric_diagram_by_hands,
      foreign_key: "well_id",
      primary_key: "well_id"

  has_many :well_wg_last,
      foreign_key: "well_id",
      primary_key: "well_id"
  has_many :well_w_graph_error,
      foreign_key: "well_id",
      primary_key: "well_id"

  has_one :well_wg_std, 
    foreign_key: "well_id",
    primary_key: "well_id"
  has_many :well_wg_std_m, 
    foreign_key: "well_id",
    primary_key: "well_id"

  has_many :well_hour_q, 
    foreign_key: "well_id",
    primary_key: "well_id"
  has_many :well_hq_last,
    foreign_key: "well_id",
    primary_key: "well_id"
  has_many :well_day_q,
    foreign_key: "well_id",
    primary_key: "well_id"
  has_one :daily_output_last, 
    foreign_key: "well_id",
    primary_key: "well_id"
  has_many :well_separator,
    foreign_key: "jh",
    primary_key: "well_id"

  has_many :dump_box,
    foreign_key: "well_id",
    primary_key: "well_id"
  has_many :dump_box_last,
    foreign_key: "well_id",
    primary_key: "well_id"

  has_many :well_alarm,
    foreign_key: "well_id",
    primary_key: "well_id"
  has_many :well_a_last,
    foreign_key: "well_id",
    primary_key: "well_id"
  has_many :start_stop,
    foreign_key: "well_id",
    primary_key: "well_id"

  has_many :start_stop_contrls,
    foreign_key: "well_id",
    primary_key: "well_id"
  has_many :start_stop_contrl_lasts,
    foreign_key: "well_id",
    primary_key: "well_id"

  has_one :rod_pump_base_last, 
    foreign_key: "well_id",
    primary_key: "well_id"

  has_many :rod_pump_base, 
    foreign_key: "well_id",
    primary_key: "well_id"

  # belongs_to :water_well_base,
  #   foreign_key: "well_id",
  #   primary_key: "well_id"
  
  has_many :water_well_bases,
    foreign_key: "well_id",
    primary_key: "well_id"

  has_one :water_well_base_last,
    foreign_key: "well_id",
    primary_key: "well_id"

  has_many :water_well_base_lasts,
    foreign_key: "well_id",
    primary_key: "well_id"

  has_many :water_well_data, through: :water_well_base_last
  has_many :water_well_data_last, through: :water_well_base_last

  has_many :start_stop_last, 
    foreign_key: "well_id",
    primary_key: "well_id"

  has_many :assessments,
    foreign_key: "well_id",
    primary_key: "well_id"

  has_many :well_sensor_relations,
    foreign_key: "well_id",
    primary_key: "well_id"

  has_many :well_running_parameters,
    foreign_key: "well_id",
    primary_key: "well_id"

  has_many :well_repaire_reports,
    foreign_key: "well_id",
    primary_key: "well_id"

  has_many :big_pot_data,
      foreign_key: "pot_id",
      primary_key: "well_id"
  has_many :big_pot_data_last,
      foreign_key: "pot_id",
      primary_key: "well_id"
  has_many :big_pot_bases,
      foreign_key: "pot_id",
      primary_key: "well_id"
  has_many :big_pot_base_lasts,
      foreign_key: "pot_id",
      primary_key: "well_id"

  has_many :sewage_pool_data,
      foreign_key: "pool_id",
      primary_key: "well_id"
  has_many :sewage_pool_data_last,
      foreign_key: "pool_id",
      primary_key: "well_id"
  has_many :sewage_pool_bases,
      foreign_key: "pool_id",
      primary_key: "well_id"
  has_many :sewage_pool_base_lasts,
      foreign_key: "pool_id",
      primary_key: "well_id"

  has_many :flowmeter_data,
      foreign_key: "flow_id",
      primary_key: "well_id"
  has_many :flowmeter_data_last,
      foreign_key: "flow_id",
      primary_key: "well_id"
  has_many :flowmeter_bases,
      foreign_key: "flow_id",
      primary_key: "well_id"
  has_many :flowmeter_base_lasts,
      foreign_key: "flow_id",
      primary_key: "well_id"

  has_many :weight_indicator_bases,
      foreign_key: "well_id",
      primary_key: "well_id"
  has_many :weight_indicator_base_lasts,
      foreign_key: "well_id",
      primary_key: "well_id"
  has_many :weight_indicators,
      foreign_key: "well_id",
      primary_key: "well_id"
  has_many :weight_indicator_lasts,
      foreign_key: "well_id",
      primary_key: "well_id"

  has_many :mix_pump_frequencies,
      foreign_key: "pump_id",
      primary_key: "well_id"
  has_many :mix_pump_frequency_last,
      foreign_key: "pump_id",
      primary_key: "well_id"
  has_many :mix_pump_frequency_bases,
      foreign_key: "pump_id",
      primary_key: "well_id"
  has_many :mix_pump_frequency_base_lasts,
      foreign_key: "pump_id",
      primary_key: "well_id"

  has_many :mix_pump_pressures,
      foreign_key: "pump_id",
      primary_key: "well_id"
  has_many :mix_pump_pressure_last,
      foreign_key: "pump_id",
      primary_key: "well_id"
  has_many :mix_pump_pressure_bases,
      foreign_key: "pump_id",
      primary_key: "well_id"
  has_many :mix_pump_pressure_base_lasts,
      foreign_key: "pump_id",
      primary_key: "well_id"

  has_many :check_valves,
      foreign_key: "well_id",
      primary_key: "well_id"

  has_many :check_valve_lasts, -> { lasts }, :class_name => 'CheckValve',
      foreign_key: "well_id",
      primary_key: "well_id"

  has_many :check_valve_dailys,
      foreign_key: "well_id",
      primary_key: "well_id"

  has_many :check_valve_daily_lasts,
      foreign_key: "well_id",
      primary_key: "well_id"

  has_many :water_rates,
      foreign_key: "well_id",
      primary_key: "well_id"

  has_many :water_rate_lasts,
      foreign_key: "well_id",
      primary_key: "well_id"

  has_many :water_rate_dailys,
      foreign_key: "well_id",
      primary_key: "well_id"

  accepts_nested_attributes_for :rod_pump_base_last

  # alias_attribute :well_id, :Well_ID
  # alias_attribute :well_name, :Well_Name
  # alias_attribute :well_base_name, :Well_Name
  alias_attribute :name, :well_name

  # added for electric pump well in old system
  has_many :electric_pump_well_base2,
    foreign_key: "Well_ID",
    primary_key: "well_id"
  has_many :electric_pump_well_data, through: :electric_pump_well_base2
  has_many :electric_pump_well_data_lasts, through: :electric_pump_well_base2
  has_many :electric_pump_well_alarms, through: :electric_pump_well_base2
  has_many :electric_pump_well_alarm_lasts, through: :electric_pump_well_base2
   # added for electric pump well in old system

  # region well
  has_many :region_wells,foreign_key: "well_id",primary_key: "well_id",:dependent => :destroy
  has_many :regions, through: :region_wells
  
 #.limit return a array of objects
  def latest_graph n
  	self.well_w_graph.order('record_time desc').limit n
  end

#.first return a object of class
#这个函数是用来查找某个井的最新的标准功图，如果WellWGStdM存放历史标准功图，WellWGStd只存放最新的标准功图的话，这个函数暂时不用
  def latest_graph_std
    self.well_wg_std #.order('record_time desc').first
  end

  def company_name
    k = [self.name, :company_name]
    Rails.cache.write( k, self.team.company_name ) unless Rails.cache.exist?( k )
    Rails.cache.fetch( k )
  end

  def base_area_name
    k = [self.name, :base_area_name]
    Rails.cache.write( k, self.team.base_area_name ) unless Rails.cache.exist?( k )
    Rails.cache.fetch( k )
  end

  def team_name
    k = [self.name, :team_name]
    Rails.cache.write( k, self.team.team_name ) unless Rails.cache.exist?( k )
    Rails.cache.fetch( k )
  end

  def group_name
    '"wellbases"."well_id"'
  end

    def data_order_field
      "well_id"
    end

  def all_well_bases
    WellBase.where(well_id: self.well_id)
  end

  def well_bases
    [self]
  end

end