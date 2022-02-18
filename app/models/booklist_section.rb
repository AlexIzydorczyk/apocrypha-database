class BooklistSection < ApplicationRecord
  belongs_to :booklist
  has_many :booklist_references, dependent: :destroy
  belongs_to :manuscript, optional: true
  belongs_to :modern_source, optional: true
end
