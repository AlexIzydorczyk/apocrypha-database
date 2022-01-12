class Ownership < ApplicationRecord
  belongs_to :booklet, optional: true
  belongs_to :person, optional: true
  belongs_to :institution, optional: true
  belongs_to :location, optional: true
  belongs_to :religious_order, optional: true
end
