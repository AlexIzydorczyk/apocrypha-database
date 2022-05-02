class Person < ApplicationRecord
	has_many :ownerships, dependent: :nullify
	has_many :contents, foreign_key: "author_id", dependent: :nullify
	has_many :texts, dependent: :nullify
	has_many :booklists, dependent: :nullify, foreign_key: "scribe_id"
	has_many :booklists, dependent: :nullify, foreign_key: "library_owner_id"
	has_many :person_references, dependent: :destroy
	has_many :modern_sources, through: :person_references, source: :record, source_type: "ModernSource", as: :record
	has_many :texts, through: :person_references, source: :record, source_type: "Text", as: :record
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
		[self.first_name_vernacular, self.middle_name_vernacular, self.prefix_vernacular, self.last_name_vernacular, self.suffix_vernacular].select{ |s| s.present? }.join(" ")
	end

	def years
		self.birth_date.present? && self.death_date.present? ? "(#{self.birth_date} - #{self.death_date})" : ""
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
