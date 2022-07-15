class Section < ApplicationRecord
  belongs_to :text
  belongs_to :incipit_language, optional: true, class_name: "Language"
  belongs_to :explicit_language, optional: true, class_name: "Language"
end
