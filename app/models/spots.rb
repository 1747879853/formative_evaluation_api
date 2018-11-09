module Spots
  extend ActiveSupport::Concern

  included do
    scope :clock, ->(n) { 
      adapter = Rails.configuration.database_configuration[Rails.env]["adapter"]
      # adapter = ActiveRecord::Base.connection_config[:adapter]
      case adapter
      when 'postgresql'
        where("date_part('hour', record_time)=?", n)
      when 'oracle_enhanced'
        where("to_number(to_char(record_time,'hh'))=?", n)
      when 'mysql2'
        where("HOUR(`record_time`)=?", n)
      when 'sqlserver'
        where("DATEPART(hh, record_time)=?", n)
      end
    }
    scope :latest, -> { joins('LEFT JOIN well_w_graphs c2 ON well_w_graphs.id = c2.id AND well_w_graphs.record_time < c2.record_time').where('c2.id is NULL') }
    scope :latest_n, ->(n) { order('record_time desc').limit(n) }
    scope :latest_n_ids, ->(n) { select('id').order('record_time desc').limit(n) }
    # scope :latest_ids, ->(n) { group('well_base_id').order('well_time desc').limit(n).select('id') }
    scope :latest_ids, ->(n) { select('DISTINCT ON (well_base_id) id ').order('well_base_id, record_time desc') }
    scope :stuff, -> {
      subquery = "(#{latest_ids.to_sql})"
      where("#{table_name}.id IN (#{subquery})")
    }

    scope :not_audited, -> { where(well_compflag: 1) }
    scope :not_audited, -> { where(well_compflag: 1) }
    scope :not_audited, -> { where(well_compflag: 1) }
    scope :not_audited, -> { where(well_compflag: 1) }
  end

  module ClassMethods
    def to_csv csv, wgraphics
      # csv = StringIO.new
      wgraphics.each do |wgraph|
        csv << '**SW源头数据格式**'.encode('gbk') << "\r\n"
        csv << wgraph.well_id << "\r\n"
        csv << wgraph.date_format << "\r\n"
        csv << wgraph.time_format << "\r\n"
        csv << wgraph.stroke_times << "\r\n"
        csv << wgraph.stroke_length << "\r\n"
        csv << 'WELLTEK油井远程工况监控系统'.encode('gbk') << "\r\n"
        csv << '示功图传感器'.encode('gbk') << "\r\n"
        csv << '001' << "\r\n"
        csv << wgraph.max_load << "\r\n"
        csv << wgraph.min_load << "\r\n"
        csv << wgraph.rod_power << "\r\n"
        csv << wgraph.diagram_area << "\r\n"
        csv << wgraph.dot_num << "\r\n"
        wgraph.dot_num.times do |i|
          csv << wgraph.spots[i].join(',') << "\r\n"
        end
      end
      # csv.string
    end

    def to_xls csv, wgraphics
      wgraphics.each_with_index do |wgraph, i|
        csv << "#{I18n.t(:well_num).encode('gbk')}, #{wgraph.well_id}" << "\r\n"
        csv << "#{I18n.t(:date).encode('gbk')}, #{wgraph.date_format}" << "\r\n"
        csv << "#{I18n.t(:time).encode('gbk')}, #{wgraph.time_format}" << "\r\n"
        csv << "#{I18n.t(:well_times).encode('gbk')}, #{wgraph.stroke_times}" << "\r\n"
        csv << "#{I18n.t(:well_distance).encode('gbk')}, #{wgraph.stroke_length}" << "\r\n"
        csv << "#{I18n.t(:index_num).encode('gbk')}, #{i+1}" << "\r\n"
        csv << "#{I18n.t(:well_maxload).encode('gbk')}, #{wgraph.max_load}" << "\r\n"
        csv << "#{I18n.t(:well_minload).encode('gbk')}, #{wgraph.min_load}" << "\r\n"
        csv << "#{I18n.t(:well_rodpow).encode('gbk')}, #{wgraph.rod_power}" << "\r\n"
        csv << "#{I18n.t(:well_area).encode('gbk')}, #{wgraph.diagram_area}" << "\r\n"
        csv << "#{I18n.t(:displacement).encode('gbk')}, #{I18n.t(:load).encode('gbk')}" << "\r\n"
        wgraph.dot_num.times do |i|
          csv << wgraph.spots[i].join(',') << "\r\n"
        end
      end
      # csv.string
    end

    # def clocks clk
    #   adapter = Rails.configuration.database_configuration[Rails.env]["adapter"]
    #   # adapter = ActiveRecord::Base.connection_config[:adapter]
    #   case adapter
    #   when 'postgresql'
    #     where("date_part('hour', well_time)=?", clk)
    #   when 'oracle_enhanced'
    #     where("to_number(to_char(well_time,'hh'))=?", clk)
    #   when 'mysql2'
    #     'mysql2'
    #   end
    # end
  end

  # alias_attribute :well_id, :well_ID

  def id
    self.ids.to_s
  end

  def spots
    m = self.moves.strip.split(';').map(&:to_f)
    l = self.loads.strip.split(';').map(&:to_f)
    if m.size!=0 && l.size!=0
      first_spot = [m[0], l[0]]
      m.zip(l) << first_spot
    else
      []
    end
  end

  def spots_normalized
    m_max = self.moves.strip.split(';').map(&:to_f).max; m_max=1 if m_max == 0
    l_max = self.loads.strip.split(';').map(&:to_f).max; l_max=1 if l_max == 0
    l_min = self.loads.strip.split(';').map(&:to_f).min; l_min=0 if l_min == 0
    m = self.moves.strip.split(';').map(&:to_f).map{|n|n/m_max}
    l = self.loads.strip.split(';').map(&:to_f).map{|n|(n-l_min)/(l_max-l_min)}
    if m.size!=0 && l.size!=0
      first_spot = [m[0], l[0]]
      m.zip(l) << first_spot
    else
      []
    end    
  end

  def spots_normalized_slr
    m_max = self.moves.strip.split(';').map(&:to_f).max; m_max=1 if m_max == 0
    l_max = self.loads.strip.split(';').map(&:to_f).max; l_max=1 if l_max == 0
    l_min = self.loads.strip.split(';').map(&:to_f).min; l_min=0 if l_min == 0
    m = self.moves.strip.split(';').map(&:to_f).map{|n|n/m_max}
    l = self.loads.strip.split(';').map(&:to_f).map{|n|(n-l_min)/(l_max-l_min)}
    slr = SimpleLinearRegression.new(m, l)
    slr
  end

  def spots_fuck_ie n
    m = self.moves.strip.split(';').map(&:to_f)
    m=m.each_slice(n).map{|arr| arr.inject(0.0) { |sum, el| sum + el } / arr.size}
    l = self.loads.strip.split(';').map(&:to_f)
    l=l.each_slice(n).map{|arr| arr.inject(0.0) { |sum, el| sum + el } / arr.size}

    first_spot = [m[0], l[0]]
    m.zip(l) << first_spot
   end

  def spotsm
  	m = self.moves.strip.split(';').map(&:to_f)
  end

  def spotsl
    p self.moves
    p self.loads
    p self.spots
  	l = self.loads.strip.split(';').map(&:to_f)
  end

  def quantity_out_of_range
    hq_quantity = self.try(:output_weight).to_f
    yesterday_quantity = self.try(:average_weight).to_f

    if yesterday_quantity == 0
      false
    elsif ((hq_quantity - yesterday_quantity) / yesterday_quantity).abs > Oil.quantity_out_of_range
      true
    else
      false
    end
  end

  def quantity_zero
    hq_quantity = self.try(:output_weight).to_f
    hq_quantity == 0.0
  end

  def spots_up_down
    m = self.moves.strip.split(';').map(&:to_f)
    l = self.loads.strip.split(';').map(&:to_f)
    min_idx = m.index(m.min)
    max_idx = m.index(m.max)

    up = []; down = [];

    if min_idx < max_idx
      l_1 = l[min_idx..max_idx]
      l_2 = l[max_idx..m.count]+l[0..min_idx]
      l1 = l_1.count > 0 ? l_1.inject{|s,d|s+d} / l_1.count : 0
      l2 = l_2.count > 0 ? l_2.inject(0){|s,d|s+d} / l_2.count : 0
      if l1 > l2
        up = m.slice(min_idx..max_idx).zip(l.slice(min_idx..max_idx))
        down = m.slice(max_idx..m.count).zip(l.slice(max_idx..m.count)) + m.slice(0..min_idx).zip(l.slice(0..min_idx))
      else
        up = m.slice(max_idx..m.count).zip(l.slice(max_idx..m.count)) + m.slice(0..min_idx).zip(l.slice(0..min_idx))
        down = m.slice(min_idx..max_idx).zip(l.slice(min_idx..max_idx))
      end
    else
      l_1 = l[min_idx..m.count]+l[0..max_idx]
      l_2 = l[max_idx..min_idx]
      l1 = l_1.count > 0 ? l_1.inject{|s,d|s+d} / l_1.count : 0
      l2 = l_2.count > 0 ? l_2.inject(0){|s,d|s+d} / l_2.count : 0
      if l1 > l2
        up = m.slice(min_idx..m.count).zip(l.slice(min_idx..m.count)) + m.slice(0..max_idx).zip(l.slice(0..max_idx))
        down = m.slice(max_idx..min_idx).zip(l.slice(max_idx..min_idx))
      else
        up = m.slice(max_idx..min_idx).zip(l.slice(max_idx..min_idx))
        down = m.slice(min_idx..m.count).zip(l.slice(min_idx..m.count)) + m.slice(0..max_idx).zip(l.slice(0..max_idx))
      end
    end

    # if min_idx < max_idx
    #   up = m.slice(min_idx..max_idx).zip(l.slice(min_idx..max_idx))
    #   down = m.slice(max_idx..m.count).zip(l.slice(max_idx..m.count)) + m.slice(0..min_idx).zip(l.slice(0..min_idx))
    # else
    #   down = m.slice(max_idx..min_idx).zip(l.slice(max_idx..min_idx))
    #   up = m.slice(min_idx..m.count).zip(l.slice(min_idx..m.count)) + m.slice(0..max_idx).zip(l.slice(0..max_idx))
    # end
    [up, down]
  end

  def spots_normalized_up_down
    m_max = self.moves.strip.split(';').map(&:to_f).max; m_max=1 if m_max == 0
    l_max = self.loads.strip.split(';').map(&:to_f).max; l_max=1 if l_max == 0
    l_min = self.loads.strip.split(';').map(&:to_f).min; l_min=0 if l_min == 0
    m = self.moves.strip.split(';').map(&:to_f).map{|n|n/m_max}
    l = self.loads.strip.split(';').map(&:to_f).map{|n|(n-l_min)/(l_max-l_min)}

    min_idx = m.index(m.min)
    max_idx = m.index(m.max)

    up = []; down = [];

    if min_idx < max_idx
      l1 = l[min_idx..max_idx].inject{|s,d|s+d}
      l2 = (l[max_idx..m.count]+l[0..min_idx]).inject(0){|s,d|s+d}
      if l1 > l2
        up = m.slice(min_idx..max_idx).zip(l.slice(min_idx..max_idx))
        down = m.slice(max_idx..m.count).zip(l.slice(max_idx..m.count)) + m.slice(0..min_idx).zip(l.slice(0..min_idx))
      else
        up = m.slice(max_idx..m.count).zip(l.slice(max_idx..m.count)) + m.slice(0..min_idx).zip(l.slice(0..min_idx))
        down = m.slice(min_idx..max_idx).zip(l.slice(min_idx..max_idx))
      end
    else
      l1 = (l[min_idx..m.count]+l[0..max_idx]).inject(0){|s,d|s+d}
      l2 = l[max_idx..min_idx].inject(0){|s,d|s+d}
      if l1 > l2
        up = m.slice(min_idx..m.count).zip(l.slice(min_idx..m.count)) + m.slice(0..max_idx).zip(l.slice(0..max_idx))
        down = m.slice(max_idx..min_idx).zip(l.slice(max_idx..min_idx))
      else
        up = m.slice(max_idx..min_idx).zip(l.slice(max_idx..min_idx))
        down = m.slice(min_idx..m.count).zip(l.slice(min_idx..m.count)) + m.slice(0..max_idx).zip(l.slice(0..max_idx))
      end
    end

    # if min_idx < max_idx
    #   up = m.slice(min_idx..max_idx).zip(l.slice(min_idx..max_idx))
    #   down = m.slice(max_idx..m.count).zip(l.slice(max_idx..m.count)) + m.slice(0..min_idx).zip(l.slice(0..min_idx))
    # else
    #   down = m.slice(max_idx..min_idx).zip(l.slice(max_idx..min_idx))
    #   up = m.slice(min_idx..m.count).zip(l.slice(min_idx..m.count)) + m.slice(0..max_idx).zip(l.slice(0..max_idx))
    # end
    [up, down]
  end

  def load_average
    m = self.moves.strip.split(';').map(&:to_f)
    l = self.loads.strip.split(';').map(&:to_f)
    min_idx = m.index(m.min)
    max_idx = m.index(m.max)

    up = []; down = [];

    if min_idx < max_idx
      l1 = l[min_idx..max_idx].inject{|s,d|s+d}
      l2 = (l[max_idx..m.count]+l[0..min_idx]).inject(0){|s,d|s+d}
      if l1 > l2
        up = m.slice(min_idx..max_idx).zip(l.slice(min_idx..max_idx))
        down = m.slice(max_idx..m.count).zip(l.slice(max_idx..m.count)) + m.slice(0..min_idx).zip(l.slice(0..min_idx))
      else
        up = m.slice(max_idx..m.count).zip(l.slice(max_idx..m.count)) + m.slice(0..min_idx).zip(l.slice(0..min_idx))
        down = m.slice(min_idx..max_idx).zip(l.slice(min_idx..max_idx))
      end
    else
      l1 = (l[min_idx..m.count]+l[0..max_idx]).inject(0){|s,d|s+d}
      l2 = l[max_idx..min_idx].inject(0){|s,d|s+d}
      if l1 > l2
        up = m.slice(min_idx..m.count).zip(l.slice(min_idx..m.count)) + m.slice(0..max_idx).zip(l.slice(0..max_idx))
        down = m.slice(max_idx..min_idx).zip(l.slice(max_idx..min_idx))
      else
        up = m.slice(max_idx..min_idx).zip(l.slice(max_idx..min_idx))
        down = m.slice(min_idx..m.count).zip(l.slice(min_idx..m.count)) + m.slice(0..max_idx).zip(l.slice(0..max_idx))
      end
    end

    # if min_idx < max_idx
    #   up = m.slice(min_idx..max_idx).zip(l.slice(min_idx..max_idx))
    #   down = m.slice(max_idx..m.count).zip(l.slice(max_idx..m.count)) + m.slice(0..min_idx).zip(l.slice(0..min_idx))
    # else
    #   down = m.slice(max_idx..min_idx).zip(l.slice(max_idx..min_idx))
    #   up = m.slice(min_idx..m.count).zip(l.slice(min_idx..m.count)) + m.slice(0..max_idx).zip(l.slice(0..max_idx))
    # end

    up_count = up.count
    up_loads = up[up_count-10-50..up_count-1-10].map{|e|e[1]}
    up_average = up_loads.inject{ |sum, el| sum + el }.to_f / up_loads.size

    down_count = down.count
    down_loads = down[down_count-10-30..down_count-1-10].map{|e|e[1]}
    down_average = down_loads.inject{ |sum, el| sum + el }.to_f / down_loads.size

    [up_average, down_average]
  end

  def load_average2
    m = self.moves.strip.split(';').map(&:to_f)
    l = self.loads.strip.split(';').map(&:to_f)
    min_idx = m.index(m.min)
    max_idx = m.index(m.max)
    max_idx_point1 = self.point1

    up = []; down = [];

    if min_idx < max_idx
      l1 = l[min_idx..max_idx].inject{|s,d|s+d}
      l2 = (l[max_idx..m.count]+l[0..min_idx]).inject(0){|s,d|s+d}
      if l1 > l2
        up = m.slice(min_idx..max_idx).zip(l.slice(min_idx..max_idx))
      else
        up = m.slice(max_idx..m.count).zip(l.slice(max_idx..m.count)) + m.slice(0..min_idx).zip(l.slice(0..min_idx))
      end
    else
      l1 = (l[min_idx..m.count]+l[0..max_idx]).inject(0){|s,d|s+d}
      l2 = l[max_idx..min_idx].inject(0){|s,d|s+d}
      if l1 > l2
        up = m.slice(min_idx..m.count).zip(l.slice(min_idx..m.count)) + m.slice(0..max_idx).zip(l.slice(0..max_idx))
      else
        up = m.slice(max_idx..min_idx).zip(l.slice(max_idx..min_idx))
      end
    end
    if min_idx < max_idx_point1
      if max_idx_point1 - min_idx < 100
        down = m.slice(min_idx..max_idx_point1).zip(l.slice(min_idx..max_idx_point1))
      else
        down = m.slice(max_idx_point1..m.count).zip(l.slice(max_idx_point1..m.count)) + m.slice(0..min_idx).zip(l.slice(0..min_idx))
      end
    else
      if min_idx - max_idx_point1 < 100
        down = m.slice(max_idx_point1..min_idx).zip(l.slice(max_idx_point1..min_idx))
      else
        down = m.slice(min_idx..m.count).zip(l.slice(min_idx..m.count)) + m.slice(0..max_idx_point1).zip(l.slice(0..max_idx_point1))
      end
    end

    # if min_idx < max_idx
    #   up = m.slice(min_idx..max_idx).zip(l.slice(min_idx..max_idx))
    #   down = m.slice(max_idx_point1..m.count).zip(l.slice(max_idx_point1..m.count)) + m.slice(0..min_idx).zip(l.slice(0..min_idx))
    # else
    #   up = m.slice(min_idx..m.count).zip(l.slice(min_idx..m.count)) + m.slice(0..max_idx).zip(l.slice(0..max_idx))
    #   down = m.slice(max_idx_point1..min_idx).zip(l.slice(max_idx_point1..min_idx))
    # end

    up_count = up.count
    up_loads = up[up_count-10-50..up_count-1-10].map{|e|e[1]}
    up_average = up_loads.inject{ |sum, el| sum + el }.to_f / up_loads.size

    down_count = down.count
    down_loads = down[0..down_count-1].map{|e|e[1]}
    down_average = down_loads.inject{ |sum, el| sum + el }.to_f / down_loads.size

    [up_average, down_average]
  end

  def load_average_for_diagnosis
    up_down = self.spots_up_down
    up = up_down[0]; down = up_down[1];

    up_count = up.count
    up_loads = up[up_count-10-50..up_count-1-10].map{|e|e[1]}
    up_average = up_loads.inject{ |sum, el| sum + el }.to_f / up_loads.size
    up_end_loads = up[up_count-20..up_count-1].map{|e|e[1]}
    up_end_average = up_end_loads.inject{ |sum, el| sum + el }.to_f / up_end_loads.size

    down_count = down.count
    down_loads = down[down_count-10-20..down_count-1-10].map{|e|e[1]}
    down_average = down_loads.inject{ |sum, el| sum + el }.to_f / down_loads.size
    down_start_loads = down[0..20].map{|e|e[1]}
    down_start_average = down_start_loads.inject{ |sum, el| sum + el }.to_f / down_start_loads.size

    [up_average, down_average, up_end_average , down_start_average]
  end

  def diagnosis p=nil
    up_average, down_average, up_end_average , down_start_average = load_average_for_diagnosis
    fs = up_average
    f1 = fs - down_average
    fb = up_end_average / down_start_average
    f2 = up_end_average - down_average
    f3 = down_start_average - down_average
    k = spots_normalized_slr.slope.round(5)
    result = []
    result << I18n.t(GlobalConstants::DIAGNOSIS_RESULTS[0]) if f1 < 0 && (p.nil? || p[GlobalConstants::DIAGNOSIS_TYPES[0].to_s] == "on")
    result << I18n.t(GlobalConstants::DIAGNOSIS_RESULTS[1]) if fs > 20  && fs < 50 && f1 > 0 && f1 < 6 && (p.nil? || p[GlobalConstants::DIAGNOSIS_TYPES[1].to_s] == "on")
    result << I18n.t(GlobalConstants::DIAGNOSIS_RESULTS[2]) if fs < 20 && f1 > 0 && f1 < 4 && (p.nil? || p[GlobalConstants::DIAGNOSIS_TYPES[2].to_s] == "on")
    result << I18n.t(GlobalConstants::DIAGNOSIS_RESULTS[3]) if fb > 1 && fb < 1.2 && f1 > 0 && f1 < 5 && (p.nil? || p[GlobalConstants::DIAGNOSIS_TYPES[3].to_s] == "on")
    result << I18n.t(GlobalConstants::DIAGNOSIS_RESULTS[4]) if k >= 0.25 && (p.nil? || p[GlobalConstants::DIAGNOSIS_TYPES[4].to_s] == "on")
    result << I18n.t(GlobalConstants::DIAGNOSIS_RESULTS[5]) if k < 0 && (p.nil? || p[GlobalConstants::DIAGNOSIS_TYPES[5].to_s] == "on")
    result << I18n.t(GlobalConstants::DIAGNOSIS_RESULTS[6]) if k > 0 && k < 0.25 && (p.nil? || p[GlobalConstants::DIAGNOSIS_TYPES[5].to_s] == "on")
    result.join(';')
  end

  def stroke_loss
    up_down = self.spots_up_down
    up = up_down[0];
    up = up.slice(0..up.count/2)
    curvatures = []
    ignored = 5
    (ignored..up.count-2).each do |i|
      x_i = up[i][0]; y_i = up[i][1];
      x_i_1 = up[i-1][0]; y_i_1 = up[i-1][1]
      x_i_2 = up[i+1][0]; y_i_2 = up[i+1][1]
      l_i_1 = ((y_i-y_i_1)**2+(x_i-x_i_1)**2)**0.5
      l_i = ((y_i_2-y_i)**2+(x_i_2-x_i)**2)**0.5
      l_i_2 = ((y_i_1-y_i_2)**2+(x_i_1-x_i_2)**2)**0.5
      p = (l_i_1+l_i+l_i_2)/2
      if p<l_i_1 || p<l_i || p<l_i_2
        s = 0
      else
        s = (p*(p-l_i_1)*(p-l_i)*(p-l_i_2))**0.5
      end
      # puts s
      k = 4*s/(l_i_1*l_i*l_i_2)
      curvatures << k
    end
    idx = curvatures.select{|e|e>0}.each_with_index.max[1]
    up[idx+ignored][0]
  end

  def arbitary_normalized_slr xs, ys
    slr = SimpleLinearRegression.new(xs, ys)
    slr
  end

  def diagnosis2
    result = {}
    up_down = self.spots_up_down
    up = up_down[0]; down = up_down[1];
    up_count = up.count
    down_count = down.count

    up_loads = (up[up_count-40..up_count-1-10] || [[0,0]]).map{|e|e[1]}
    result[:fu]  = up_loads.inject{ |sum, el| sum + el }.to_f / up_loads.size

    down_loads = (down[down_count-25..down_count-1-5] || [[0,0]]).map{|e|e[1]}
    result[:fd] = down_loads.inject{ |sum, el| sum + el }.to_f / down_loads.size

    up_loads = (up[up_count-5..up_count-1] || [[0,0]]).map{|e|e[1]}
    result[:fum]  = up_loads.inject{ |sum, el| sum + el }.to_f / up_loads.size

    down_loads = (down[0..4] || [[0,0]]).map{|e|e[1]}
    result[:fdk] = down_loads.inject{ |sum, el| sum + el }.to_f / down_loads.size

    up_loads = (up[0..5] || [[0,0]]).map{|e|e[1]}
    result[:fuk]  = up_loads.inject{ |sum, el| sum + el }.to_f / up_loads.size

    down_loads = (down[down_count-5..down_count-1] || [[0,0]]).map{|e|e[1]}
    result[:fdm] = down_loads.inject{ |sum, el| sum + el }.to_f / down_loads.size

    down_loads = (down[0..19] || [[0,0]]).map{|e|e[1]}
    result[:fdk20] = down_loads.inject{ |sum, el| sum + el }.to_f / down_loads.size

    result[:f1] = result[:fu] - result[:fd]
    result[:f2] = result[:fum] - result[:fd]
    result[:f3] = result[:fdk] - result[:fd]
    result[:f6] = result[:fum] - result[:fu]
    result[:f7] = result[:fdk] - result[:fu]
    result[:f8] = result[:fd] - result[:fuk]
    result[:f9] = result[:fd] - result[:fdm]
    result[:f10] = result[:fu] - result[:fdk20]
    result[:f11] = result[:fdk20] - result[:fdm]

    m_max = self.moves.strip.split(';').map(&:to_f).max; m_max=1 if m_max == 0
    l_max = self.loads.strip.split(';').map(&:to_f).max; l_max=1 if l_max == 0
    l_min = self.loads.strip.split(';').map(&:to_f).min; l_min=0 if l_min == 0
    m = self.moves.strip.split(';').map(&:to_f).map{|n|n/m_max}
    l = self.loads.strip.split(';').map(&:to_f).map{|n|(n-l_min)/(l_max-l_min)}
    result[:k1] = arbitary_normalized_slr(m, l).slope

    up_down = self.spots_normalized_up_down
    up = up_down[0]; down = up_down[1];
    up_count = up.count
    down_count = down.count

    arr=(up[-10..-1] || [[0,0]])+(down[1..10] || [[0,0]])
    result[:k2] = arbitary_normalized_slr(arr.map{|e|e[0]}, arr.map{|e|e[1]}).slope

    arr=(up[1..10] || [[0,0]])+(down[-10..-1] || [[0,0]])
    result[:k3] = arbitary_normalized_slr(arr.map{|e|e[0]}, arr.map{|e|e[1]}).slope

    arr=(up[-10..-1] || [[0,0]])
    result[:k4] = arbitary_normalized_slr(arr.map{|e|e[0]}, arr.map{|e|e[1]}).slope

    arr=(down[-10..-1] || [[0,0]])
    result[:k5] = arbitary_normalized_slr(arr.map{|e|e[0]}, arr.map{|e|e[1]}).slope

    result
  end

  def diagnosis2_within_std
    result = {}
    up_down = self.spots_up_down
    up = up_down[0]; down = up_down[1];
    up_count = up.count
    down_count = down.count

    up_loads = (up[up_count-40..up_count-1-10] || [[0,0]]).map{|e|e[1]}
    result[:fu]  = up_loads.inject{ |sum, el| sum + el }.to_f / up_loads.size

    down_loads = (down[down_count-25..down_count-1-5] || [[0,0]]).map{|e|e[1]}
    result[:fd] = down_loads.inject{ |sum, el| sum + el }.to_f / down_loads.size

    result
  end

  def wgraph options = {}, wg_std_contrast = nil
    enable_custom_stroke_length = {
      output_weight: self.try(:output_weight).to_f.round(2),
      quantity_out_of_range: self.quantity_out_of_range,
    } if options[:enable_custom_stroke_length]

    stroke_length_hash = {
      stroke_length: ( self.calc_status > GlobalConstants::WGRAPH_PRE_CALC_FINISH_STATUS || self.point1.nil? || self.point2.nil?) ? [] 
        : [ [ self.spotsm[self.point1], self.spotsl[self.point2]], [ self.spotsm[self.point2],self.spotsl[self.point2]] ],
      stroke_length_color: Oil.auto_liquid_color,
      # stroke_length_2: Oil.blue_line_enabled ? [ [ 0,self.spotsl[self.point3]], [ self.spotsm[self.point3],self.spotsl[self.point3]] ] : [],
      stroke_length_2: ( self.calc_status > GlobalConstants::WGRAPH_PRE_CALC_FINISH_STATUS || self.point1.nil? || self.point2.nil?) ? [] 
        : [ [ self.spotsm[self.point1], self.spotsl[self.point1]], [ self.spotsm[self.point1],self.spotsl[self.point2]] ],
      stroke_length_2_color: Oil.point2_line_color,
      custom_stroke_length: self.point4.nil? || self.point5.nil? ? [] : 
        [ 
          [ self.point4 < 0 ? 0 : self.spotsm[self.point4], self.spotsl[self.point5] ], 
          [ self.spotsm[self.point5], self.spotsl[self.point5] ] 
        ],
      custom_stroke_length_color: Oil.custom_liquid_color,
    } if options[:enable_custom_stroke_length] || options[:stroke_length_detail]

    detail_hash={ 
      pump_dia: self.pump_diameter, 
      pump_effe: self.pump_efficiency,
      valid_distance: self.valid_length,
      has_water: self.water_ratio, #CacheController.well_base_param(self.well_id, :water_ratio),
    } if options[:stroke_length_detail]

    std = {
      std: self.well_wg_std.try(:spots),
      std_color: Oil.wgraph_std_color[self.well_wg_std.try(:std_type_colour)],
    } if options[:with_std] && self.well_wg_std.present?

    std_contrast = {
      std_contrast: wg_std_contrast.try(:spots),
      
      std_well_distance: wg_std_contrast.stroke_length,
      std_well_times: wg_std_contrast.stroke_times,
      std_well_minload: wg_std_contrast.min_load,
      std_well_maxload: wg_std_contrast.max_load,
      std_well_area: wg_std_contrast.diagram_area,
      std_well_rodpow: wg_std_contrast.rod_power,

      std_well_distance_ratio: ((self.stroke_length-wg_std_contrast.stroke_length)/wg_std_contrast.stroke_length).round(3)*100,
      std_well_times_ratio: ((self.stroke_times-wg_std_contrast.stroke_times)/wg_std_contrast.stroke_times).round(3)*100,
      std_well_minload_ratio: ((self.min_load-wg_std_contrast.min_load)/wg_std_contrast.min_load).round(3)*100,
      std_well_maxload_ratio: ((self.max_load-wg_std_contrast.max_load)/wg_std_contrast.max_load).round(3)*100,
      std_well_area_ratio: ((self.diagram_area-wg_std_contrast.diagram_area)/wg_std_contrast.diagram_area).round(3)*100,
      std_well_rodpow_ratio: ((self.rod_power-wg_std_contrast.rod_power)/wg_std_contrast.rod_power).round(3)*100,

      wgraph_color: 'red',
      std_color: Oil.wgraph_std_color[self.well_wg_std.try(:std_type_colour)],
    } if options[:with_std_contrast] && wg_std_contrast.present?

    wgraph_color_hash = {
      GlobalConstants::WGRAPH_PRE_CALC_NONE => Oil.wgraph_pre_calc_no_color,
      GlobalConstants::WGRAPH_PRE_CALC_FINISH_STATUS => Oil.wgraph_pre_calc_finish_color,
      # GlobalConstants::WGRAPH_PRE_CALC_FINISH_STATUS2 => Oil.wgraph_pre_calc_finish_color,
      # GlobalConstants::WGRAPH_PRE_CALC_ERROR_STATUS => Oil.wgraph_pre_calc_error_color,
      # GlobalConstants::WGRAPH_PRE_CALC_ERROR_STATUS2 => Oil.wgraph_pre_calc_error_color,
      :quantity_out_of_range => Oil.wgraph_quantity_out_of_range_color,
      :quantity_zero => Oil.wgraph_quantity_zero_color,
      # GlobalConstants::WGRAPH_CALC_INCLUDED_STATUS => Oil.wgraph_calc_included_color,
      GlobalConstants::WGRAPH_CALC_EXCLUDED_STATUS => Oil.wgraph_calc_excluded_color,
      GlobalConstants::WGRAPH_CALC_FINISH_STATUS => Oil.wgraph_calc_finish_color,}

    # calc_status = self.well_hour_q.calc_status
    # calc_status = self.try(:calc_status)  #self.try(:comp_status) || self.try(:calc_status)
    # calc_status = self.try(:calc_status_in_well_hour_q) || self.try(:calc_status)
    calc_status = self.try(:calc_status) || GlobalConstants::WGRAPH_PRE_CALC_FINISH_STATUS
    typ = self.class.name
    spots_color = Oil.wgraph_std_color[self.try(:std_type_colour)] if typ == WellWgStd.name
    spots_color = Oil.wgraph_last_color if typ == WellWgLast.name
    spots_color ||= wgraph_color_hash[calc_status]
    spots_color = wgraph_color_hash[:quantity_out_of_range] if 
      options[:enable_custom_stroke_length] && calc_status == GlobalConstants::WGRAPH_PRE_CALC_FINISH_STATUS && self.quantity_out_of_range
    spots_color = wgraph_color_hash[:quantity_zero] if 
      options[:enable_custom_stroke_length] && calc_status == GlobalConstants::WGRAPH_PRE_CALC_FINISH_STATUS && self.quantity_zero
    spots_color = Oil.wgraph_pre_calc_error_color if calc_status > GlobalConstants::WGRAPH_PRE_CALC_FINISH_STATUS
    spots_color ||= wgraph_color_hash[GlobalConstants::WGRAPH_PRE_CALC_FINISH_STATUS]

    {
      id: self.id,
      well_id: self.well_id,
      record_time: self.record_time.strftime('%Y-%m-%d %H:%M:%S').to_s,
      title: '',
      subtitle: '',
      subtitle_big: '',
      spots: self.spots,
      spots_up_down: options[:wgraph_up_down] ? self.spots_up_down : nil,
      spots_color: spots_color,
      well_distance: self.stroke_length,
      well_times: self.stroke_times,
      well_minload: self.min_load,
      well_maxload: self.max_load,
      well_area: self.diagram_area,
      well_rodpow: self.rod_power,
      calc_status: calc_status,
      type: typ,
    }.merge( enable_custom_stroke_length.to_h ).merge( stroke_length_hash.to_h ).merge( detail_hash.to_h ).merge( std.to_h ).merge( std_contrast.to_h )
  end

  def restful_wgraph
    {
      id: self.id,
      well_id: self.well_id,
      record_time: self.record_time.strftime('%Y-%m-%d %H:%M:%S').to_s,
      spots: self.spots,
      well_distance: self.stroke_length,
      well_times: self.stroke_times,
      well_minload: self.min_load,
      well_maxload: self.max_load,
      well_area: self.diagram_area,
      well_rodpow: self.rod_power,
      calc_status: calc_status,
    }
  end

  def date_format
    self.record_time.strftime('%Y%m%d').to_s
  end

  def time_format
    self.record_time.strftime('%H%M%S').to_s
  end

  def png_filename
    "#{self.well_id}_#{self.record_time.strftime('%Y_%m_%d_%H')}.png"
  end

  def as_json(options = {})
    {
      well_name: self.well_id,
      record_time: self.record_time.strftime('%Y-%m-%d %H:%M:%S').to_s,
      spots: self.spots,
      stroke_length: self.stroke_length,
      stroke_times: self.stroke_times,
      min_load: self.min_load,
      max_load: self.max_load,
      diagram_area: self.diagram_area,
      rod_power: self.rod_power,
      calc_status: self.calc_status,
    }
  end

end
