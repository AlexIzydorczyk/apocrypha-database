class Ownership < ApplicationRecord
  belongs_to :booklet, optional: true
  belongs_to :person, optional: true
  belongs_to :institution, optional: true
  belongs_to :location, optional: true
  belongs_to :religious_order, optional: true
  belongs_to :manuscript, optional: true

  def written_date_range
    text = ''
    if self.date_from.present? && self.date_to.present?
      text += 'circa ' if self.owner_date_is_approximate?
      text += self.date_from + ' to ' + self.date_to
    end

  end
end
