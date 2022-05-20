class Manuscript < ApplicationRecord
  belongs_to :institution, optional: true
  belongs_to :genesis_location, class_name: "Location", optional: true
  belongs_to :genesis_institution, class_name: "Institution", optional: true
  belongs_to :genesis_religious_order, class_name: "ReligiousOrder", optional: true
  has_many :scribe_references, -> { scribe }, class_name: "PersonReference", as: :record, dependent: :destroy
  has_many :scribes, through: :scribe_references, source: :person
  has_many :language_references, as: :record, dependent: :destroy
  has_many :languages, through: :language_references, as: :record
  has_many :booklets, -> { order("booklet_no ASC") }, dependent: :destroy
  has_many :modern_source_references, as: :record, dependent: :destroy
  has_many :modern_sources, through: :modern_source_references
  has_many :person_references, as: :record, dependent: :destroy
  has_many :correspondent_references, -> { correspondent }, as: :record, class_name: "PersonReference", dependent: :destroy
  has_many :correspondents, through: :correspondent_references, class_name: "Person"
  has_many :transcriber_references, -> { transcriber }, as: :record, class_name: "PersonReference", dependent: :destroy
  has_many :transcribers, through: :transcriber_references, class_name: "Person"
  has_many :compiler_references, -> { compiler }, as: :record, class_name: "PersonReference", dependent: :destroy
  has_many :compilers, through: :compiler_references, class_name: "Person"
  has_many :ownerships, -> { order("index ASC") }, dependent: :destroy
  has_many :contents, -> { order("sequence_no ASC") }, dependent: :destroy
  has_many :booklist_sections, dependent: :destroy
  has_many :manuscript_urls, -> { order("index ASC") }, dependent: :destroy

  def display_name
    d_name = [self.institution.try(:location).present? ? self.institution.location.try(:city) : self.genesis_location.try(:city), self.institution.try(:name), self.shelfmark].select{ |d| d.present? }.join(", ")
    d_name.present? ? d_name : "Untitled manuscript"
  end

  def long_display_name
    text = ""
    text = self.census_no + '. ' if self.census_no.present?
    text += [self.try(:institution).try(:location).try(:city), self.try(:institution).try(:name), self.shelfmark].join(', ')
    text
  end

  def city
    self.try(:institution).try(:location).try(:city)
  end

  def census_no_display
    self.census_no.present? ? self.census_no : (self.id.to_s + " (auto assigned)")
  end

end
