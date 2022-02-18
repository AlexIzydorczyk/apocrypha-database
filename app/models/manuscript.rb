class Manuscript < ApplicationRecord
  belongs_to :institution, optional: true
  has_many :language_references, as: :record
  has_many :languages, through: :language_references, as: :record
  has_many :booklets, -> { order("booklet_no ASC") }
  has_many :modern_source_references, as: :record
  has_many :modern_sources, through: :modern_source_references
  has_many :person_references
  has_many :correspondents, class_name: "Person", through: :person_references
  has_many :ownerships
  has_many :contents, -> { order("sequence_no ASC") }
  has_many :booklist_sections

  def display_name
    self.census_no.present? ? ("Manuscript " + self.census_no) : "Edit"
  end

  def long_display_name
    text = ""
    text = self.census_no + '. ' if self.census_no.present?
    text += [self.try(:institution).try(:location).try(:city_orig), self.try(:institution).try(:name_orig), self.shelfmark].join(', ')
    text
  end

  def city
    self.try(:institution).try(:location).try(:city_orig)
  end

end
