class Institution < ApplicationRecord
  belongs_to :location, optional: true
  belongs_to :language, optional: true
  has_many :manuscripts
  has_many :institutional_affiliations
  has_many :religious_orders, through: :institutional_affiliations
  has_many :booklets
  has_many :ownerships
  has_many :booklists

  def display_name
    self.name_orig
  end
end
