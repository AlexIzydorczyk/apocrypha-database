class ModernSource < ApplicationRecord
  belongs_to :publication_location, class_name: "Location", optional: true
  belongs_to :language, optional: true
  belongs_to :insitiution, optional: true
  belongs_to :publication_title_language, class_name: "Language", optional: true
  belongs_to :volume_title_language, class_name: "Language", optional: true
  belongs_to :part_title_language, class_name: "Language", optional: true
  belongs_to :series_title_language, class_name: "Language", optional: true
  belongs_to :title_language, class_name: "Language", optional: true
  has_many :source_urls
  has_many :modern_source_references
  has_many :booklists, through: :modern_source_references
  has_many :manuscripts, through: :modern_source_references
  has_many :texts, through: :modern_source_references
  has_many :person_references, as: :record
  has_many :author_references, -> { author }, as: :record, class_name: "PersonReference"
  has_many :authors, through: :author_references, class_name: "Person"
  has_many :editor_references, -> { editor }, as: :record, class_name: "PersonReference"
  has_many :editors, through: :editor_references, class_name: "Person"
  has_many :translator_references, -> { translator }, as: :record, class_name: "PersonReference"
  has_many :translators, through: :translator_references, class_name: "Person"
  has_many :booklist_sections

  def display_name
    self.title_orig.present? ? self.title_orig : (self.publication_title_orig.present? ? self.publication_title_orig : (self.source_type.present? ? self.source_type.humanize : "New bibliographic item"))
  end

end
