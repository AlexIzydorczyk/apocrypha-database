class Person < ApplicationRecord
	has_many :ownerships
	has_many :contents, foreign_key: "author_id"
	has_many :texts
	has_many :booklists
	has_many :person_references
	has_many :modern_sources, through: :person_references, source: :record, source_type: "ModernSource", as: :record
	has_many :texts, through: :person_references
	has_many :manuscripts, through: :person_references
	belongs_to :writing_system, optional: true

	after_initialize :set_default_writing_system
	after_update :update_modern_sources

	def update_modern_sources
		self.modern_sources.each do |ms|
			ms.set_display_name
			ms.save!
		end
	end

  def set_default_writing_system
    ws = WritingSystem.find_by(name: 'Latin')
    self.writing_system = ws if ws.present?
  end

	def full_name
		self.prefix_vernacular + ' ' + self.first_name_vernacular + ' ' + self.middle_name_vernacular + ' ' + self.last_name_vernacular + ' ' + self.suffix_vernacular
	end

	def modern_source_display in_list=true
		s = ""
		if in_list
			s = [self.first_name_vernacular, self.middle_name_vernacular, self.suffix_vernacular, self.last_name_vernacular].select{ |s| s.present? }.join(" ")
		else
			s = [self.first_name_vernacular, self.middle_name_vernacular, self.suffix_vernacular].select{ |s| s.present? }.join(" ")
			s = self.last_name_vernacular + ", " + s if self.last_name_vernacular.present?
		end
		s
	end

	def person_type
		types = self.person_references.map{ |pr| pr.reference_type }.uniq
		types.length < 2 ? types[0] : 'multiple'
	end
end
