class Booklet < ApplicationRecord
  belongs_to :manuscript, optional: true
  belongs_to :genesis_location, class_name: "Location", optional: true
  belongs_to :genesis_institution, class_name: "Location", optional: true
  belongs_to :genesis_religious_order, class_name: "Location", optional: true
  has_many :ownerships
  has_many :contents
end
