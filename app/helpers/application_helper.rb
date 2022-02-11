module ApplicationHelper
	def english_id
		Language.find_or_create_by(language_name: 'English', requires_transliteration: false).id
	end

	def latin_id
		Language.find_or_create_by(language_name: 'Latin', requires_transliteration: false).id
	end

	def sort_hash_keys obj, keys
		new_keys = obj.keys.sort_by{ |k|
			keys.include?(k) ? keys.index(k) : keys.length
		}
		new_keys.each_with_object({}) { |k,h|
			h[k] = obj[k]
		}
	end
end
