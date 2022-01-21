class Content < ApplicationRecord
  belongs_to :booklet, optional: true
  belongs_to :title, optional: true
  belongs_to :author, class_name: "Person", optional: true
  belongs_to :manuscript, optional: true
  has_many :texts

  def display_name
    # needs to be updated to include incipit
    self.title.present? && self.title.title_translation.present? ? self.title.title_translation : (self.author.present? ? (self.author.first_name + self.author.middle_name + self.author.last_name) : "")
    s = ""
    if self.title.present?
      s += "Title: " + self.title + " "
    end
    if self.title.present? && self.author.present?
      s += "| "
    end
    if self.author.present?
      s += "Author: " + self.author.full_name + " "
    end
    s.strip
  end

  def short_name
    self.title.present? ? self.title : (self.author.present? ? self.author.full_name : "Content")
  end

end
