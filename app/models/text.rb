class Text < ApplicationRecord
  belongs_to :parent, polymorphic: true, optional: true
  belongs_to :apocryphon, optional: true
end
