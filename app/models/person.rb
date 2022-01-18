class Person < ApplicationRecord
	has_many :ownerships
	has_many :contents
	has_many :texts
	has_many :booklists
	has_many :person_references
	has_many :modern_sources, through: :person_references
	has_many :texts, through: :person_references
	has_many :manuscripts, through: :person_references

	def full_name
		self.first_name + ' ' + self.last_name
	end
end
