class BooklistReference < ApplicationRecord
  belongs_to :booklist
  belongs_to :text
  belongs_to :apocryphon, optional: true
end
