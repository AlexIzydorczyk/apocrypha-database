class Manuscript < ApplicationRecord
	has_many :booklets
	has_many :texts, as: :parent

	def date_range
		if self.date_from.present? || self.date_to.present?
			'from ' + (self.date_from.present? ? self.date_from.to_s : '[unavailable]') + ' to ' + (self.date_to.present? ? self.date_to.to_s : '[unavailable]')

		else
			'unavailable'
		end
	end
end
