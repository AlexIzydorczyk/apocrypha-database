class UserGridStatesController < ApplicationController
	skip_before_action :authenticate_user!, only: %i[ get ]

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
		render json: {state: ugs.first.state, filters: ugs.first.filters, title: ugs.first.state_name }
	end

	def sort
		params[:ids].each_with_index do |id, i|
	      UserGridState.where(id: id).update_all(index: i + 1)
	    end
	    render json: {success: true}
	end

	def set_default
		UserGridState.where(record_type: params[:record_type]).all.update_all(is_default: false)
		UserGridState.find(params[:user_grid_state_id]).update(is_default: true)
		render json: {success: true}
	end

end
