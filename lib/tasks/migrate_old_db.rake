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
				abbreviation: a["_id"]
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

	task :parse_manuscripts_json => :environment do
		ma = JSON.parse(File.read('public/manuscripts_export.json'))

		puts 'count: ' + ma.count.to_s
		ma.each do |m|
			puts m["_id"]
						
			r = Manuscript.new(
				identifier: m["_id"],
				shelfmark: m["shelfMark"] || "",
				material: m["material"] || "",
				census_no: m["siglum"] || "",
				known_booklet_composition: m["booklet"].present?
			)
			r.save!

			if m["city"].present? or m["country"].present?
				l = Location.find_or_initialize_by(
					city_orig: m["city"] || "",
					country: m["country"] || "",	
				)
				l.save!
				puts l.id

				if m["repository"].present?
					i = Institution.find_or_initialize_by(
						name_orig: m["repository"].strip,
						location_id: l.try(:id)
					)
					i.save!
					r.update(institution_id: i.id)
				end
			end
			
			if m["booklet"].present? #known booklet composition

				# if m["booklet"].count > 1 #multiple booklets

					puts m["_id"] 

					m["booklet"].each_with_index do |b, i|
						br = r.booklets.create(
							pages_folios_from: parse_folios(b["ffpp"], true),
							pages_folios_to: parse_folios(b["ffpp"], false),
							booklet_no: i+1
						)

						b["contents"].each_with_index do |c, i|
							if c["notApocryphon"].present?
								t = Title.create(title_orig: c["notApocryphon"])
								br.contents.create(title_id: t.id, sequence_no: i+1)
							elsif c["apocryphon"].present? #apocryphon content
								a = c["apocryphon"]
								lang = Language.find_or_create_by(language_name: a["language"]) if a["language"].present?
								if a["title"].present?
									title = Title.find_or_create_by(title_orig: a["title"])
									title.update(language_id: lang.id) if title.language_id.blank? && lang.present?
									apoc = Apocryphon.find_or_create_by(id: title.apocryphon_id)
									content = br.contents.create(title_id: title.id, sequence_no: i+1)
								else
									apoc = Apocryphon.find_or_create_by(abbreviation: a["apocryphonId"])
									content = br.contents.create(sequence_no: i+1)
								end
								text = Text.create(
									content_id: content.id,
									text_pages_folios_from: parse_folios(a["ffpp"], true),
									text_pages_folios_to: parse_folios(a["ffpp"], false),
									notes: a["notes"] || "",
									extent: a["extent"] || "",
									manuscript_title_orig: a["msTitle"] || "",
									title_pages_folios_from: parse_single_folio(a["ffppMsTitle"]),
									title_pages_folios_to: parse_single_folio(a["ffppMsTitle"]),
									colophon_orig: a["colophon"] || "",
									colophon_pages_folios_from: parse_single_folio(a["ffppColophon"]),
									colophon_pages_folios_to: parse_single_folio(a["ffppColophon"]),
								) if ["ffpp", "notes", "extent", "msTitle", "ffppMsTitle", "colophon", "ffppColophon", "section"].any?{ |s| a[s].present? }
								a["section"].each_with_index do |s, i|
									section = Section.create(
										incipit_orig: s["incipit"] || "",
										explicit_orig: s["explicit"] || "",
										pages_folios_incipit: s["ffppIncipit"] || "",
										pages_folios_explicit: s["ffppExplicit"] || "",
										section_name: s["name"] || "",
										text_id: text.id
									)
								end if a["section"].present?

								LanguageReference.find_or_create_by(record: apoc, language_id: lang.id) if a["language"].present?

							end

						end

						b

					end

			else #unknown booklet composition
				puts m["_id"]

				m["context"]["contents"].each_with_index do |c, i|
					t = Title.create(title_orig: c)
					r.contents.create(title_id: t.id, sequence_no: i+1)
				end

			end

			if m["scribe"].present?
				r.notes += m["scribe"].map{ |s| "Scribe: " + s }.join("\n\n")
				r.save!
			end				

			if m["owner"].present?
				m["owner"].each do |o|
					l = o["location"].present? || o["diocese"].present? || o["region"].present? ? Location.find_or_create_by(
						city_orig: o["location"] || "",
						diocese_orig: o["diocese"] || "",
						country: o["region"] || "",
					) : nil
					i = Institution.find_or_create_by(
						location_id: l.id,
						name_orig: o["institution"],
					) if o["institution"].present?
					ro = ReligiousOrder.find_or_create_by(
						order_name: o["order"]
					) if o["order"].present?
					Ownership.find_or_create_by(
						location_id: l.present? ? l.id : nil,
						institution_id: i.present? ? i.id : nil,
						religious_order_id: ro.present? ? ro.id : nil,
						provenance_notes: o["notes"] || "",
						manuscript_id: r.booklets.count != 1 ? r.id : nil,
						booklet_id: r.booklets.count == 1 ? r.booklets.first.id : nil,
					)
				end
			end
		end
	end
end

def parse_folios(ffpp, from)
	if ffpp.present?
		split = ffpp.gsub(/.+?(?=ff)/, '').gsub('ff.', '').strip.split('-')
		from ? split.first : split.last
	else
		""
	end
end

def parse_single_folio(ffpp)
	ffpp.present? ? ffpp.split(' ').last : ''
end
