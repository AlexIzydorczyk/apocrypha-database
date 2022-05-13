class UserGridStatesController < ApplicationController
	def save
		ugs = UserGridState.find_or_create_by(
			user: params[:state_name].present? ? nil : current_user,
			record_type: params[:record_type],
			state_name: params[:state_name],
		)
		ugs.state = JSON.parse(params[:state])
		ugs.filters = JSON.parse(params[:filters])
		ugs.save!
	end

	def destroy
		UserGridState.find_by(id: params[:id]).destroy
		redirect_to sections_path
	end

	def get
		ugs_params = params[:id].present? ? {id: params[:id]} : {record_type: params[:record_type], user: current_user}
		ugs = UserGridState.where(ugs_params)
		render json: {state: ugs.first.state, filters: ugs.first.filters}
	end

	private

end
