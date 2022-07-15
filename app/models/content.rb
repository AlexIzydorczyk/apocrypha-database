class Content < ApplicationRecord
  belongs_to :booklet, optional: true
  belongs_to :title, optional: true
  belongs_to :author, class_name: "Person", optional: true
  belongs_to :manuscript, optional: true
  has_one :text, dependent: :destroy

  scope :with_text, -> { joins(:text).uniq }

  def display_name
    # needs to be updated to include incipit
    # self.title.present? && self.title.title_translation.present? ? self.title.title_translation : (self.author.present? ? (self.author.first_name_vernacular + self.author.middle_name_vernacular + self.author.last_name_vernacular) : "")
    s = []
    s.push(self.author.full_name.strip) if self.author.present?
    if self.title.present? && self.title.italicized?
      s.push("<i>" + self.title.title_english + "</i>")
    elsif self.title.present?
      s.push(self.title.title_english)
    end
    s.join(', ').html_safe
  end

  def short_name
    self.title.present? ? self.title.title_english : (self.author.present? ? self.author.full_name : "Content")
  end

  def parent
    self.manuscript_id.present? ? self.manuscript : self.booklet.presence
  end

  def show_display_name
    s = []
    s.push(self.author.full_name.strip) if self.author.present?
    if self.title.present?
      if self.title.apocryphon_id.present?
        self.title.italicized? ? s.push("<span class='highlight'><i>" + self.title.title_english + "</i></span>") : s.push("<span class='highlight'>" + self.title.title_english + "</span>")
      else
        self.title.italicized? ? s.push("<i>" + self.title.title_english + "</i>") : s.push(self.title.title_english)
      end
    end
    s.join(', ').html_safe
  end

end
