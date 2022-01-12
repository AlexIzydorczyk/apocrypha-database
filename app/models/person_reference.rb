class PersonReference < ApplicationRecord
  belongs_to :record, polymorphic: true
  belongs_to :person
end
