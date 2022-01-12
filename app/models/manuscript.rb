class Manuscript < ApplicationRecord
  belongs_to :institution, optional: true
  has_many :languages_references, as: :record
  has_many :languages, through: :language_references, as: :record
  has_many :booklets
  has_many :modern_source_references, as: :record
  has_many :manuscripts, through: :modern_source_references
  has_many :person_references
  has_many :correspondents, class_name: "Person", through: :person_references
end
