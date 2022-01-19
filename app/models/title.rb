class Title < ApplicationRecord
  belongs_to :apocryphon, optional: true
  belongs_to :language, optional: true
  has_many :contents

  def title_english
    #check for language
    self.title_translation.present? ? self.title_translation : self.title_orig
  end
end
