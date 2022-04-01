class ReligiousOrder < ApplicationRecord
	has_many :institutional_affiliations, dependent: :nullify
	has_many :insitiutions, through: :institutional_affiliations
	has_many :booklets, foreign_key: "genesis_religious_order_id", dependent: :nullify
	has_many :manuscripts, foreign_key: "genesis_religious_order_id", dependent: :nullify
	has_many :ownerships, dependent: :nullify
	has_many :booklists, dependent: :nullify

	def display_name 
		self.order_name
	end
end
