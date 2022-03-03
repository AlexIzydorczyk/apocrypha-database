class ModernSourceReference < ApplicationRecord
  belongs_to :record, polymorphic: true
  belongs_to :modern_source, optional: true
end
