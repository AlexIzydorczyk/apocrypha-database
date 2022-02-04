class Apocryphon < ApplicationRecord
	has_many :languages, as: :record
	has_many :titles
	has_many :booklists
	has_many :language_references, as: :record
  has_many :languages, through: :language_references, as: :record
  
	def display_name
		'Apocryphon ' + self.apocryphon_no + ' : ' + (self.main_english_title_id.present? ? self.main_eng_title : self.main_lat_title).to_s
	end

	def main_eng_title
		Title.find(self.main_english_title_id).title_orig if self.main_english_title_id.present?
	end
	
	def main_lat_title
		Title.find(self.main_latin_title_id).title_orig if self.main_latin_title_id.present?
	end

end
