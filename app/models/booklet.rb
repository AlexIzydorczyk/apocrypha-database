class Booklet < ApplicationRecord
  belongs_to :manuscript, optional: true
  belongs_to :genesis_location, class_name: "Location", optional: true
  belongs_to :genesis_institution, class_name: "Institution", optional: true
  belongs_to :genesis_religious_order, class_name: "ReligiousOrder", optional: true
  has_one :scribe_reference, class_name: "PersonReference", as: :record
  has_one :scribe, through: :scribe_reference, source: :person
  has_many :ownerships
  has_many :contents, -> { order("sequence_no ASC") }

  def display_name
    "Booklet " + self.booklet_no
  end
end
