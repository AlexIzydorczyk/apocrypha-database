class Booklist < ApplicationRecord
  belongs_to :library_owner, class_name: "Person", optional: true
  belongs_to :institution, optional: true
  belongs_to :location, optional: true
  belongs_to :religious_order, optional: true
  belongs_to :scribe, class_name: "Person", optional: true
  belongs_to :language, optional: true
  has_many :texts, through: :booklist_references
  has_many :modern_source_references, as: :record
  has_many :modern_sources, through: :modern_source_references
  has_many :booklist_sections, dependent: :destroy

  def display_name
    "Booklist " + self.id.to_s
  end
end
