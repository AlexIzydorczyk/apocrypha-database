class Apocryphon < ApplicationRecord
	has_many :languages, as: :record
	has_many :titles, dependent: :destroy
	has_many :language_references, as: :record, dependent: :destroy
  	has_many :languages, through: :language_references, as: :record

	before_destroy :destroy_children
  
	def display_name 
		title = self.main_latin_title_id.present? ? self.main_lat_title : self.main_eng_title
		title.present? ? title : self.apocryphon_no
	end

	def main_eng_title
		Title.find(self.main_english_title_id).title_orig if self.main_english_title_id.present?
	end
	
	def main_lat_title
		Title.find(self.main_latin_title_id).title_orig if self.main_latin_title_id.present?
	end

	def destroy_children
		self.titles.destroy_all
	end

	def languages_list
		titles = Title.where(apocryphon_id: self.id).map(&:id)
    contents = Content.where(title_id: titles).map(&:id)
    texts = Text.where(content_id: contents).map(&:id)
    langRef = LanguageReference.where(record_type: 'Text').where(record_id: texts).map(&:language_id)
    list_of_languages = Language.where(id: langRef).map(&:language_name).join(', ')
    list_of_languages
	end

end
