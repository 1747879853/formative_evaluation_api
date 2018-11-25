class Api::V1::RegionWellsController < Api::V1::BaseController
	def get_region_welllist
		unauthorized and return unless Auth.check('region-manage/region-wellBase', current_user)
		region_id = params.require(:id)
		# 获取所有没被分配区块的油井id
		regionWells = RegionWell.where("region_id != (?)",region_id).select("well_id").all.distinct.to_a
		ids = []
		regionWells.each do |i|
			ids.append(i.well_id)
		end
		if(ids.length>0)
			h = {
					"well_data": WellBase.where(show_status: 1).where("well_id NOT IN (?)",Array.wrap(ids)),
					"well_list": RegionWell.where(region_id: params.require(:id)).all
			}
		else
			h = {
					"well_data": WellBase.where(show_status: 1).all,
					"well_list": RegionWell.where(region_id: params.require(:id)).all
			}
		end
		render json: h

	end

	def post_region_welllist
		unauthorized and return unless Auth.check('region-manage/region-wellBase', current_user)
    	arr = params.require(:params)[:wellList]
	  	region_id = params.require(:params)[:region_id]
			RegionWell.where(region_id: region_id).all.destroy_all
	  	arr.each do |i|
	  		#   here is always have preblerms cause database rollback
	  		#   RegionWell Load (59.6ms)  SELECT  "region_well_bases".* FROM "region_well_bases" WHERE "region_well_bases"."id" = $1 AND "region_well_bases"."well_id" = $2 AND "region_well_bases"."region_id" = $3 AND "region_well_bases"."created_at" = $4 AND "region_well_bases"."updated_at" = $5 LIMIT $6  [["id", 3], ["well_id", "s"], ["region_id", 1], ["created_at", "2018-11-06 20:19:12.759744"], ["updated_at", "2018-11-06 20:19:12.759745"], ["LIMIT", 1]]
			#   (89.1ms)  BEGIN
			#   Region Load (81.4ms)  SELECT  "regions".* FROM "regions" WHERE "regions"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
			#   (106.0ms)  ROLLBACK
	  		# 	RegionWell.find_or_create_by(well_id: i.to_s,region_id: region_id,created_at: Time.now,updated_at: Time.now)
	  		sql = ActiveRecord::Base.connection()
	  		sql.exec_insert "insert into region_wells(well_id,region_id,created_at,updated_at) values ('"+i.to_s()+"',"+region_id.to_s()+",now(),now())"
	  	end
	    render json: RegionWell.where(region_id: region_id).all.size
	end
end