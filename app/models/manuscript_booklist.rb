class ManuscriptBooklist < ApplicationRecord
  belongs_to :manuscript
  belongs_to :booklist
end
