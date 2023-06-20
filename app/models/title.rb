class Title < ApplicationRecord
  belongs_to :apocryphon, optional: true
  belongs_to :language, optional: true
  has_many :contents

  before_destroy :unlink_title

  def title_english
    #check for language
    self.title_translation.present? ? self.title_translation : self.title_orig
  end

  def title_english_italic
    if self.italicized?
      "<i>" + self.title_english + "</i>"
    else
      self.title_english
    end
  end

  def unlink_title
    Apocryphon.where(main_english_title_id: self.id).update_all(main_english_title_id: nil)
    Apocryphon.where(main_latin_title_id: self.id).update_all(main_latin_title_id: nil)
    texts = Text.joins(:content).where(contents: {title_id: self.id})
    if texts.present?
      texts.each{ |text| text.content.update(title_id: nil) }
    else
      self.contents.destroy_all
    end
  end

end
