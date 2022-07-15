class ApplicationController < ActionController::Base
	before_action :authenticate_user!
	before_action :set_grouped_people, if: :user_signed_in?
	skip_before_action :authenticate_user!, only: %i[ how_to_use about contact research ]
	
	def index
	end

	def set_grouped_people
		@scribes = Person.joins(:person_references).where(person_references: { reference_type: 'scribe' })
		@authors = (Person.joins(:person_references).where(person_references: { reference_type: 'author' }) + Person.joins(:contents) + Person.joins("INNER JOIN booklists ON booklists.scribe_id = people.id").all).uniq
		@editors = Person.joins(:person_references).where(person_references: { reference_type: 'editor' })
		@translators = Person.joins(:person_references).where(person_references: { reference_type: 'translator' })
		@correspondents = Person.joins(:person_references).where(person_references: { reference_type: 'correspondent' })
		@transcribers = Person.joins(:person_references).where(person_references: { reference_type: 'transcriber' })
		@compilers = Person.joins(:person_references).where(person_references: { reference_type: 'compiler' })
		@owners = (Person.joins(:ownerships).all + Person.joins("INNER JOIN booklists ON booklists.library_owner_id = people.id").all).uniq
		@no_role = Person.where.not(id: @scribes.map(&:id) + @authors.map(&:id) + @editors.map(&:id) + @translators.map(&:id) + @correspondents.map(&:id) + @transcribers.map(&:id) + @compilers.map(&:id) + @owners.map(&:id))
		@grouped_people = { 
			scribe: @scribes.uniq,
			author: @authors.uniq,
			editor: @editors.uniq,
			translator: @translators.uniq,
			correspondent: @correspondents.uniq,
			transcriber: @transcribers.uniq,
			compiler: @compilers.uniq,
			owner: @owners.uniq,
			no_role: @no_role.uniq,
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
