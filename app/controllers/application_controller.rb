class ApplicationController < ActionController::Base
	before_action :authenticate_user!
	before_action :set_grouped_people, if: :user_signed_in?
	#skip_before_action :authenticate_user!, only: %i[ index ]
	
	def index
	end

	def set_grouped_people
		@grouped_people = Person.all.order('last_name_vernacular', 'first_name_vernacular').group_by{ |person|
			types = person.person_references.map{ |pr| pr.reference_type }.filter{ |t| t.present? }.uniq
			types.length < 1 ? 'no_role_assigned' : (types.length > 1 ? 'multiple_roles' : types.first)
		}	
	end

	def allow_for_editor
		unless current_user.present? and current_user.adm_editor?
			flash[:alert] = 'access not authorized'
			redirect_back(fallback_location: root_path)
		end
	end

	def allow_for_admin
		unless current_user.present? and current_user.admin?
			flash[:alert] = 'access not authorized'
			redirect_back(fallback_location: root_path)
		end
	end

end
