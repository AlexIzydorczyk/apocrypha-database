class Title < ApplicationRecord
  belongs_to :apocryphon, optional: true
  belongs_to :language, optional: true
  has_many :contents

  before_destroy :unlink_title

  def title_english
    #check for language
    self.title_translation.present? ? self.title_translation : self.title_orig
  end

  def unlink_title
    Apocryphon.where(main_english_title_id: self.id).update_all(main_english_title_id: nil)
    Apocryphon.where(main_latin_title_id: self.id).update_all(main_latin_title_id: nil)
  end
end
