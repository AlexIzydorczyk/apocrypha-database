class Manuscript < ApplicationRecord
	has_many :booklets
	has_many :texts, as: :parent
end
