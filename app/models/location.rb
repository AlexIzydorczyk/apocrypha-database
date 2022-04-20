class Location < ApplicationRecord
	has_many :ownerships, dependent: :nullify
	has_many :booklets, foreign_key: "genesis_location_id", dependent: :nullify
	has_many :booklists, dependent: :nullify
	has_many :modern_sources, foreign_key: "publication_location_id", dependent: :nullify
	belongs_to :city_writing_system, class_name: "WritingSystem", optional: true
	belongs_to :region_writing_system, class_name: "WritingSystem", optional: true
	belongs_to :diocese_writing_system, class_name: "WritingSystem", optional: true

	after_initialize :set_default_writing_system

  def set_default_writing_system
    ws = WritingSystem.find_by(name: 'Latin')
    if ws.present?
    	self.city_writing_system = ws
    	self.region_writing_system = ws
    	self.diocese_writing_system = ws
    end
  end


	def city_region_country
		[self.city, (self.diocese.present? ? 'dioc. ' + self.diocese : nil), self.region, self.country].select{ |s| s.present? }.join(", ")
	end

	def city_country
		self.city + ', ' + self.country  
	end
end
