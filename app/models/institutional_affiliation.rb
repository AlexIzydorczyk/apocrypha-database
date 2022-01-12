class InstitutionalAffiliation < ApplicationRecord
  belongs_to :institution, optional: true
  belongs_to :religious_order, optional: true
end
