class Content < ApplicationRecord
  belongs_to :booklet, optional: true
  belongs_to :title, optional: true
  belongs_to :author, class_name: "Person", optional: true
  belongs_to :manuscript, optional: true
  has_one :text

  scope :with_text, -> { joins(:text).uniq }

  def display_name
    # needs to be updated to include incipit
    self.title.present? && self.title.title_translation.present? ? self.title.title_translation : (self.author.present? ? (self.author.first_name_vernacular + self.author.middle_name_vernacular + self.author.last_name_vernacular) : "")
    s = []
    s.push(self.title.title_english) if self.title.present?
    s.push(self.author.full_name) if self.author.present?
    s.join(', ')
  end

  def short_name
    self.title.present? ? self.title.title_english : (self.author.present? ? self.author.full_name : "Content")
  end

  def parent
    self.manuscript_id.present? ? self.manuscript : self.booklet.presence
  end

end
