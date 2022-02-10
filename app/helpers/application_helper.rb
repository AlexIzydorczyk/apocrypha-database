module ApplicationHelper
	def english_id
		Language.find_or_create_by(language_name: 'English', requires_transliteration: false).id
	end

	def latin_id
		Language.find_or_create_by(language_name: 'Latin', requires_transliteration: false).id
	end
end
