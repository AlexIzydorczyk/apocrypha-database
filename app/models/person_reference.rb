class PersonReference < ApplicationRecord
  belongs_to :record, polymorphic: true
  belongs_to :person
  belongs_to :editor, foreign_key: :person_id, class_name: "Person"
  belongs_to :translator, foreign_key: :person_id, class_name: "Person"
end
