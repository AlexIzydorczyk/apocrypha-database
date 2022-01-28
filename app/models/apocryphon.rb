class Apocryphon < ApplicationRecord
	has_many :languages, as: :record
	has_many :titles
	has_many :booklists
	has_many :language_references, as: :record
  has_many :languages, through: :language_references, as: :record

	def display_name
		'Apocryphon '+self.id.to_s
	end
end
