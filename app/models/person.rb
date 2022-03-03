class Person < ApplicationRecord
	has_many :ownerships
	has_many :contents
	has_many :texts
	has_many :booklists
	has_many :person_references
	has_many :modern_sources, through: :person_references
	has_many :texts, through: :person_references
	has_many :manuscripts, through: :person_references
	belongs_to :language, optional: true

	def full_name
		self.first_name_vernacular + ' ' + self.middle_name_vernacular + ' ' + self.last_name_vernacular
	end

	def modern_source_display in_list=true
		s = ""
		if in_list
			s = [self.first_name_vernacular, self.middle_name_vernacular, self.suffix, self.last_name_vernacular].select{ |s| s.present? }.join(" ")
		else
			s = [self.first_name_vernacular, self.middle_name_vernacular, self.suffix].select{ |s| s.present? }.join(" ")
			s = self.last_name_vernacular + ", " + s if self.last_name_vernacular.present?
		end
		s
	end

	def person_type
		types = self.person_references.map{ |pr| pr.reference_type }.uniq
		types.length < 2 ? types[0] : 'multiple'
	end
end
