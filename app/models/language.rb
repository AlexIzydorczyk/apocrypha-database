class Language < ApplicationRecord
	has_many :titles
	has_many :booklists
	has_many :institutions
	has_many :modern_sources
end
