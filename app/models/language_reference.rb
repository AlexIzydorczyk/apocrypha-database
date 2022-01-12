class LanguageReference < ApplicationRecord
  belongs_to :record, polymorphic: true
  belongs_to :language
end
