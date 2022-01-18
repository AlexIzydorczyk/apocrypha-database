class Location < ApplicationRecord
	has_many :ownerships
	has_many :booklets
	has_many :booklists
	has_many :modern_sources

	def city_region_country
		self.city_english + ', ' + self.region_english + ', ' + self.country  
	end
end
