class Person < ApplicationRecord
	has_many :ownerships
	has_many :contents
	has_many :texts
	has_many :booklists
	has_many :person_references
	has_many :modern_sources, through: :person_references
	has_many :texts, through: :person_references
	has_many :manuscripts, through: :person_references
	belongs_to :language

	def full_name
		self.first_name_vernacular + ' ' + self.middle_name_vernacular + ' ' + self.last_name_vernacular
	end
end
