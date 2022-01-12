class ReligiousOrder < ApplicationRecord
	has_many :institutional_affiliations
	has_many :insitiutions, through: :institutional_affiliations
	has_many :booklets
	has_many :ownerships
	has_many :booklists
end
