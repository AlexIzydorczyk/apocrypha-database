class UserGridStatesController < ApplicationController
	def save
		ugs = UserGridState.find_or_create_by( user: current_user, record_type: params[:record_type] )
		ugs.state =  JSON.parse(params[:state])
		ugs.save!
	end

	def get
		ugs = UserGridState.where(record_type: params[:record_type], user: current_user)
		render json: {state: ugs.first.state}
	end
end
