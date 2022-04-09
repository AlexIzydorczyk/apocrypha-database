module ApplicationHelper
	def english_id
		Language.find_or_create_by(language_name: 'English', requires_transliteration: false).id
	end

	def latin_id
		Language.find_or_create_by(language_name: 'Latin', requires_transliteration: false).id
	end

	def latin_writing_system_id
		WritingSystem.find_or_create_by(name: "Latin").id
	end

	def sort_hash_keys obj, keys
		new_keys = obj.keys.sort_by{ |k|
			keys.include?(k) ? keys.index(k) : keys.length
		}
		sorted = new_keys.each_with_object({}) { |k,h|
			h[k] = obj[k]
		}
		sorted
	end

	def format_date date
		date.strftime("%-d %B, %Y")
	end

	def page_title
		if action_name == "edit" || action_name == "show"
			if controller_name == "manuscripts"
				Manuscript.find(params[:id]).display_name
			elsif controller_name == "booklets"
				b = Booklet.find(params[:id])
				"Booklet " + b.booklet_no + ' - ' + b.manuscript.display_name
			elsif controller_name == "texts"
				strip_tags(Text.find(params[:id]).content.display_name)
			elsif controller_name == "apocrypha"
				strip_tags(Apocryphon.find(params[:id]).display_name)
			elsif controller_name == "modern_sources"
				strip_tags(ModernSource.find(params[:id]).display_name_html_safe)
			elsif controller_name == "booklists"
				strip_tags(Booklist.find(params[:id]).display_name)
			else
				controller_name.humanize
			end
		elsif action_name == "index"
			controller_name == 'application' ? 'Home' : controller_name.humanize.gsub("Modern sources", "Bibliography") + ' Grid'
		else
			controller_name.humanize
		end
	end
end
