class Title < ApplicationRecord
  belongs_to :apocryphon, optional: true
  belongs_to :language, optional: true
  has_many :contents
end
