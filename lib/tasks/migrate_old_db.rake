desc "create apocrypha objects from old database json"

namespace :migrate_old_db do
	
	task :parse_apocrypha_json => :environment do
		
		english_id = Language.find_by(language_name: "English")
		latin_id = Language.find_by(language_name: "Latin")

		ap = JSON.parse(File.read('public/apocrypha_export.json'))

		ap.each do |a|

			created_at = DateTime.parse(a["createdAt"].class == String ? a["createdAt"] : a["createdAt"]["$date"])
			updated_at = a["updatedAt"].present? ? DateTime.parse(a["updatedAt"].class == String ? a["updatedAt"] : a["updatedAt"]["$date"]) : created_at

			puts a["_id"]

			r = Apocryphon.new(
				apocryphon_no: a["apocryphonId"] || "",
				cant_no: a["CANT"] || "",
				e_clavis_no: a["eClavis"] || "",
				bhl_no: a["BHL"] || "",
				bhg_no: a["BHG"] || "",
				e_clavis_link: a["linkToEClavis"] || "",
				created_at: created_at,
				updated_at: updated_at,
			)
			r.save!

			if a["englishTitle"].present?
				t = r.titles.new(
					title_orig: a["englishTitle"],
					language_id: english_id,
					created_at: created_at,
					updated_at: updated_at,
				)
				t.save!
				r.update(main_english_title_id: t.id)
			end

			if a["latinTitle"].present?
				t = r.titles.new(
					title_orig: ActionView::Base.full_sanitizer.sanitize(a["latinTitle"], ['i']),
					language_id: latin_id,
					created_at: created_at,
					updated_at: updated_at,
				)
				t.save!
				r.update(main_latin_title_id: t.id)
			end

			a["otherEnglishTitles"].each do |title_string|
				t = r.titles.new(
					title_orig: title_string,
					language_id: english_id,
					created_at: created_at,
					updated_at: updated_at,
				)
				t.save!
			end if a["otherEnglishTitles"].present?

			a["otherLatinTitles"].each do |title_string|
				t = r.titles.new(
					title_orig: ActionView::Base.full_sanitizer.sanitize(title_string, ['i']),
					language_id: latin_id,
					created_at: created_at,
					updated_at: updated_at,
				)
				t.save!
			end if a["otherLatinTitles"].present?


			a["languages"].each do |language|
				l = Language.find_or_initialize_by(language_name: language)
				l.save!
				lr = LanguageReference.new(record: r, language_id: l.id)
				lr.save!
			end if a["languages"].present?

		end

	end

	task :parse_booklist_json => :environment do
		
		bl = JSON.parse(File.read('public/booklists_export.json'))

		bl.each do |b|

			puts b["_id"]

			created_at = DateTime.parse(b["createdAt"].class == String ? b["createdAt"] : b["createdAt"]["$date"])
			updated_at = b["updatedAt"].present? ? DateTime.parse(b["updatedAt"].class == String ? b["updatedAt"] : b["updatedAt"]["$date"]) : created_at

			date_from = b["dateRange"].present? ? b["dateRange"]["from"] : ""
			date_to = b["dateRange"].present? ? b["dateRange"]["to"] : ""

			language_id = b["language"].present? ? Language.find_or_create_by(language_name: b["language"]).id : nil
			puts language_id

			r = Booklist.find_or_initialize_by(
				title_orig: b["title"],
			)
			r.update(
				booklist_type: b["attestationType"] || "",
				specific_date: b["specificDate"] || "",
				created_at: created_at,
				updated_at: updated_at,
				date_from: date_from,
				date_to: date_to,
				language_id: language_id,
			)

			r.booklist_sections.new(
				relevant_text_orig: b["relevantText"] || "",
				heading_orig: b["chapterRef"] || "",
			)
			r.save!

			if b["booklist"].present?

				bo = b["booklist"]["booksOwner"]

				if bo["location"].present? or bo["diocese"].present? or bo["region"].present?
					l = Location.find_or_initialize_by(
						city_orig: bo["location"] || "",
						diocese_orig: bo["diocese"] || "",
						country: bo["region"] || "",	
					)
					l.save!
					r.update(location_id: l.id)
				end

				if bo["institution"].present?
					i = Institution.find_or_initialize_by(
						name_orig: bo["institution"].strip,
						location_id: r.location_id
					)
					i.save!
					r.update(institution_id: i.id)
				end

				if bo["religiousOrder"].present?
					ro = ReligiousOrder.find_or_initialize_by(
						order_name: bo["religiousOrder"].strip
					)
					ro.save!
					r.update(religious_order_id: ro.id)
				end

			end

			if b["author"].present?
				s = Person.find_or_initialize_by(
					first_name_vernacular: b["author"].strip
				)
				s.save!
				r.update(scribe_id: s.id)
			end

		end

	end
	
end
