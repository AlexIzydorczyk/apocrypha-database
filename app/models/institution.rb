class Institution < ApplicationRecord
  belongs_to :location, optional: true
  has_many :manuscripts
  has_many :institutional_affiliations
  has_many :religious_orders, through: :institutional_affiliations
  has_many :booklets
  has_many :ownerships
  has_many :booklists
  has_many :modern_sources
  belongs_to :writing_system, optional: true

  after_initialize :set_default_writing_system

  after_update :update_modern_sources

  def update_modern_sources
    self.modern_sources.each do |ms|
      ms.set_display_name
      ms.save!
    end
  end

  def set_default_writing_system
    ws = WritingSystem.find_by(name: 'Latin')
    self.writing_system = ws if ws.present?
  end


  def display_name
    s = ""
    title = self.writing_system.present? && self.writing_system != WritingSystem.find_by(name: "Latin") ? self.name_orig_transliteration : self.name_orig
    s += title + " " if title.present?
    s += "[" + self.name_english + "]" unless self.name_english.blank?
    s
  end

  def long_display_name
    self.name_orig
  end
end
