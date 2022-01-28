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

  def display_name
    self.identifier.present? ? ("Manuscript " + self.census_no) : "Edit"
  end

end
