class Language < ApplicationRecord
	has_many :titles
	has_many :booklists
end
