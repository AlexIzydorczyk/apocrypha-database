desc "delete objects from db"

namespace :writing_systems do
	task :create_defaults => :environment do
		
		%w(Latin Greek Arabic Aramaic Armenian Coptic Cyrillic Ge'ez Georgian Glagolitic Hebrew).each{ |name|
			WritingSystem.find_or_create_by(name: name)
		}

	end
end