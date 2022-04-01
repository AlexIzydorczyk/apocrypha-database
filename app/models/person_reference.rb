class PersonReference < ApplicationRecord
  belongs_to :record, polymorphic: true
  belongs_to :person
  belongs_to :author, foreign_key: :person_id, class_name: "Person"
  belongs_to :editor, foreign_key: :person_id, class_name: "Person"
  belongs_to :translator, foreign_key: :person_id, class_name: "Person"
  belongs_to :correspondent, foreign_key: :person_id, class_name: "Person"
  belongs_to :transcriber, foreign_key: :person_id, class_name: "Person"
  belongs_to :compiler, foreign_key: :person_id, class_name: "Person"
  # belongs_to :modern_source, foreign_key: :record_id, class_name: "ModernSource", validate: false
  scope :author, -> { where(reference_type: "author") }
  scope :editor, -> { where(reference_type: "editor") }
  scope :translator, -> { where(reference_type: "translator") }
  scope :correspondent, -> { where(reference_type: "correspondent") }
  scope :transcriber, -> { where(reference_type: "transcriber") }
  scope :compiler, -> { where(reference_type: "compiler") }
end
