class Language < ApplicationRecord
	has_many :titles
	has_many :booklists
	has_many :institutions
end
