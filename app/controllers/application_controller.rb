class ApplicationController < ActionController::Base
	before_action :authenticate_user!
	before_action :set_grouped_people, if: :user_signed_in?
	
	def index
	end

	def set_grouped_people
		@grouped_people = Person.all.group_by{ |person|
			types = person.person_references.map{ |pr| pr.reference_type }.filter{ |t| t.present? }.uniq
			types.length < 1 ? 'no_role_assigned' : (types.length > 1 ? 'multiple_roles' : types.first)
		}	
	end
end
