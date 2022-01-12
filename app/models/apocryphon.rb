class Apocryphon < ApplicationRecord
	has_many :languages, as: :record
	has_many :titles
	has_many :booklists
end
