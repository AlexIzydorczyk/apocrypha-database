class BooklistSection < ApplicationRecord
  belongs_to :booklist
  has_many :booklist_references, dependent: :destroy
  belongs_to :manuscript, optional: true
  has_many :modern_source_references, as: :record
  has_many :modern_source, through: :modern_source_references
end
