class PersonReference < ApplicationRecord
  belongs_to :record, polymorphic: true
  belongs_to :person
  belongs_to :author, foreign_key: :person_id, class_name: "Person"
  belongs_to :editor, foreign_key: :person_id, class_name: "Person"
  belongs_to :translator, foreign_key: :person_id, class_name: "Person"
  scope :author, -> { where(reference_type: "author") }
  scope :editor, -> { where(reference_type: "editor") }
  scope :translator, -> { where(reference_type: "translator") }
end
