class WritingSystem < ApplicationRecord
	has_many :modern_sources
	has_many :texts
	has_many :locations
end
