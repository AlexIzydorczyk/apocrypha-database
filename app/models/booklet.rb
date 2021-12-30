class Booklet < ApplicationRecord
	belongs_to :manuscript
	has_many :texts
end
