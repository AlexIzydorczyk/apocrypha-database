class Institution < ApplicationRecord
  belongs_to :location, optional: true
  belongs_to :language, optional: true
  has_many :manuscripts
  has_many :institutional_affiliations
  has_many :religious_orders, through: :institutional_affiliations
  has_many :booklets
  has_many :ownerships
  has_many :booklists
  has_many :modern_sources

  def display_name
    self.name_orig

    s = ""
    title = self.language.present? && self.language.requires_transliteration ? self.name_orig_transliteration : name_orig
    s += title + " " if title.present?
    english = Language.find_or_create_by(language_name: 'English', requires_transliteration: false)
    s += "[" + self.name_english + "]" unless self.language == english || self.name_english.blank?
    s
  end

  def long_display_name
    self.location.present? ? self.location.city_country + ', ' + self.name_orig : '(no location specified)' + self.name_orig
  end
end
