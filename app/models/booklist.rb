class Booklist < ApplicationRecord
  belongs_to :library_owner, class_name: "Person", optional: true
  belongs_to :institution, optional: true
  belongs_to :location, optional: true
  belongs_to :religious_order, optional: true
  belongs_to :scribe, class_name: "Person", optional: true
  belongs_to :language, optional: true
  has_many :texts, through: :booklist_references
  has_many :modern_source_references, as: :record, dependent: :destroy
  has_many :modern_sources, through: :modern_source_references
  has_many :booklist_sections, dependent: :destroy
  has_many :person_references, as: :record, dependent: :destroy
  has_many :author_references, -> { author }, as: :record, class_name: "PersonReference"
  has_many :authors, through: :author_references, class_name: "Person"

  def display_name
    "Booklist " + self.id.to_s
  end

  def apocrypha_mentioned
    rec = BooklistReference.where(booklist_section_id: BooklistSection.where(booklist_id: self.id).pluck(:id)).map{ |br| br.record.display_name }
    rec.present? ? rec.reject(&:blank?).join(', ') : ""
  end

  def extant_as_ms
     rec = BooklistSection.where(booklist_id: self.id).map{|bs| bs.try(:manuscript).try(:display_name) }
     rec.present? ? rec.reject(&:blank?).join('; ') : ""
  end

  def display_library_owner
    arr = []
    arr.push(self.library_owner.full_name) if self.library_owner.present?
    arr.push(self.institution.display_name) if self.institution.present?
    arr.push(self.religious_order.display_name) if self.religious_order.present?
    arr.push(self.location.city_region_country) if self.location.present?
    to_return = arr.join(', ')
    to_return = to_return + '.' if to_return.present?
    to_return
  end
end
