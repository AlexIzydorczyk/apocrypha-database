class Institution < ApplicationRecord
  belongs_to :location, optional: true
  has_many :manuscripts, dependent: :nullify
  has_many :institutional_affiliations, dependent: :nullify
  has_many :religious_orders, through: :institutional_affiliations
  has_many :booklets, foreign_key: "genesis_institution_id", dependent: :nullify
  has_many :ownerships, dependent: :nullify
  has_many :booklists, dependent: :nullify
  has_many :modern_sources, dependent: :nullify
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
    title = self.writing_system.present? && self.writing_system != WritingSystem.find_by(name: "Latin") ? self.name_transliteration : self.name
    s += title + " " if title.present?
    s += "[" + self.name_alt + "]" unless self.name_alt.blank?
    s
  end

  def display_name_with_city_country
    if self.location.present?
      self.location.city_country + ', '+ self.display_name
    else
      self.display_name
    end
  end

  def long_display_name
    self.name
  end
end
