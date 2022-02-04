class BooklistReference < ApplicationRecord
  belongs_to :booklist_section
  belongs_to :record, polymorphic: true
end
