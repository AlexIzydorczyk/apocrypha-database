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
      text += 'circa ' unless self.date_exact?
      text += self.date_from + ' to ' + self.date_to
    end
    text
  end

  def display_name
    [
      ([
        self.person.try(:full_name),
        self.person.try(:years)
      ].select{ |t| t.present? }.join(' ')),
      self.institution.try(:display_name),
      self.religious_order.try(:order_name)
    ].select{ |s| s.present? }.join(', ')
  end

  def full_display_name
    text = self.display_name
    text += "; " if self.display_name.present? && self.location.try(:city_region_country).present?
    text += self.location.try(:city_region_country) if self.location.try(:city_region_country).present?
    text += ". " if self.display_name.present? || self.location.try(:city_region_country).present?
    text += self.provenance_notes
    text
  end

  def full_display_name_with_date
    text = self.written_date_range
    text += "|" if self.written_date_range.present? && self.specific_date.present?
    text += "ca." unless self.date_exact
    text += self.specific_date 
    text += " - " if self.written_date_range.present? || self.specific_date.present?
    text += self.full_display_name
    text
  end
end
