class Location < ApplicationRecord
	has_many :ownerships
	has_many :booklets
	has_many :booklists
	has_many :modern_sources
	belongs_to :city_orig_writing_system, class_name: "WritingSystem", optional: true
	belongs_to :region_orig_writing_system, class_name: "WritingSystem", optional: true
	belongs_to :diocese_orig_writing_system, class_name: "WritingSystem", optional: true

	after_initialize :set_default_writing_system

  def set_default_writing_system
    ws = WritingSystem.find_by(name: 'Latin')
    if ws.present?
    	self.city_orig_writing_system = ws
    	self.region_orig_writing_system = ws
    	self.diocese_orig_writing_system = ws
    end
  end


	def city_region_country
		[self.diocese_orig, self.city_orig, self.region_orig, self.country].select{ |s| s.present? }.join(", ")
	end

	def city_country
		self.city_orig + ', ' + self.country  
	end
end
