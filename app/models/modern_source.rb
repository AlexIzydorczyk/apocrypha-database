class ModernSource < ApplicationRecord
  belongs_to :publication_location, class_name: "Location", optional: true
  has_many :source_urls
  has_many :modern_source_references
  has_many :booklists, through: :modern_source_references
  has_many :manuscripts, through: :modern_source_references
  has_many :texts, through: :modern_source_references
  has_many :person_references
  has_many :people, through: :person_references
end
