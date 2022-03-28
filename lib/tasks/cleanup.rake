desc "delete objects from db"

namespace :cleanup do
	task :full_database_wipe => :environment do
		puts "starting cleanup".blue

		puts "starting ModernSourceReference"
		ModernSourceReference.destroy_all
		puts "complete ModernSourceReference".green

		puts "starting PersonReference"
		PersonReference.destroy_all
		puts "complete PersonReference".green

		puts "starting BooklistReference"
		BooklistReference.destroy_all
		puts "complete BooklistReference".green

		puts "starting LanguageReference"
		LanguageReference.destroy_all
		puts "complete LanguageReference".green

		puts "starting TextUrl"
		TextUrl.destroy_all
		puts "complete TextUrl".green

		puts "starting Text"
		Text.destroy_all
		puts "complete Text".green

		puts "starting Content"
		Apocryphon.update_all(content_id: nil)
		Content.destroy_all
		puts "complete Content".green

		puts "starting Ownership"
		Ownership.destroy_all
		puts "complete Ownership".green

		puts "starting BooklistSection"
		BooklistSection.destroy_all
		puts "complete BooklistSection".green

		puts "starting Booklet"
		Booklet.destroy_all
		puts "complete Booklet".green

		puts "starting Manuscript"
		Manuscript.destroy_all
		puts "complete Manuscript".green

		puts "starting Booklist"
		Booklist.destroy_all
		puts "complete Booklist".green

		puts "starting Title"
		Title.destroy_all
		puts "complete Title".green

		puts "starting Apocryphon"
		Apocryphon.destroy_all
		puts "complete Apocryphon".green

		puts "starting SourceUrl"
		SourceUrl.destroy_all
		puts "complete SourceUrl".green

		puts "starting ModernSource"
		ModernSource.destroy_all
		puts "complete ModernSource".green

		puts "starting Institution"
		Institution.destroy_all
		puts "complete Institution".green

		puts "starting ReligiousOrder"
		ReligiousOrder.destroy_all
		puts "complete ReligiousOrder".green

		puts "starting Location"
		Location.destroy_all
		puts "complete Location".green

		puts "starting Person"
		Person.destroy_all
		puts "complete Person".green

		puts "starting Language"
		Language.destroy_all
		puts "complete Language".green

		ActiveRecord::Base.connection.tables.each do |t|
			puts ('reseting ids for '+t.to_s).red
		  ActiveRecord::Base.connection.reset_pk_sequence!(t)
		end

	end

	task :clean_blank_modern_sources => :environment do
		ModernSource.all.each do |ms|
			ms.destroy if ms.display_name == '.'
		end
	end

	task :italics_for_titles => :environment do
		Title.all.each do |title|
			if title.title_orig.starts_with?('<i>')
				puts 'cleaning this: '+title.title_orig
				title.italicized = true
				title.title_orig = ActionView::Base.full_sanitizer.sanitize(title.title_orig, ['i'])
				title.save!
			end
		end
	end
end