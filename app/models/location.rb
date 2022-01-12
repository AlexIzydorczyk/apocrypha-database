class Location < ApplicationRecord
	has_many :ownerships
	has_many :booklets
	has_many :booklists
	has_many :modern_sources
end
