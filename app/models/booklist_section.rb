class BooklistSection < ApplicationRecord
  belongs_to :booklist
  has_many :booklist_references, dependent: :destroy
end
