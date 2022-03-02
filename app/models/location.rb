class Location < ApplicationRecord
	has_many :ownerships
	has_many :booklets
	has_many :booklists
	has_many :modern_sources
	belongs_to :city_orig_language, class_name: "Language", optional: true
	belongs_to :region_orig_language, class_name: "Language", optional: true
	belongs_to :diocese_orig_language, class_name: "Language", optional: true

	def city_region_country
		[self.city_orig, self.region_orig, self.country].select{ |s| s.present? }.join(", ")
	end

	def city_country
		self.city_orig + ', ' + self.country  
	end
end
