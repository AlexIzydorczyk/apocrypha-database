class ModernSource < ApplicationRecord
  belongs_to :publication_location, class_name: "Location", optional: true
  belongs_to :language, optional: true
  belongs_to :insitiution, optional: true
  belongs_to :publication_title_language, class_name: "Language", optional: true
  belongs_to :volume_title_language, class_name: "Language", optional: true
  belongs_to :part_title_language, class_name: "Language", optional: true
  belongs_to :series_title_language, class_name: "Language", optional: true
  belongs_to :title_language, class_name: "Language", optional: true
  has_many :source_urls
  has_many :modern_source_references
  has_many :booklists, through: :modern_source_references
  has_many :manuscripts, through: :modern_source_references
  has_many :texts, through: :modern_source_references
  has_many :person_references, as: :record
  has_many :author_references, -> { author }, as: :record, class_name: "PersonReference"
  has_many :authors, through: :author_references, class_name: "Person"
  has_many :editor_references, -> { editor }, as: :record, class_name: "PersonReference"
  has_many :editors, through: :editor_references, class_name: "Person"
  has_many :translator_references, -> { translator }, as: :record, class_name: "PersonReference"
  has_many :translators, through: :translator_references, class_name: "Person"
  has_many :booklist_sections

  def display_name
    self.title_orig.present? ? self.title_orig : (self.publication_title_orig.present? ? self.publication_title_orig : (self.source_type.present? ? self.source_type.humanize : "New bibliographic item"))
  end

  private

  def book_display
    s = ""
    
    # name (initial)
    if self.author_type == 'corporate'
      s += self.insitiution.display_name + " "
    elsif self.authors.count > 0
      s += person_list(self.authors, false, true) + " "
    elsif self.editors.count > 0
      s += person_list(self.editors, true, true) + " "
    end

    # title
    s += self.publication_title_language.requires_transliteration ? self.publication_title_transliteration + " " : self.publication_title_orig + " "
    s.strip!
    english = Language.find_or_create_by(language_name: 'English', requires_transliteration: false)
    s += " [" + self.publication_title_translation + "]" unless self.publication_title_language == english || self.publication_title_translation.blank?
    s += ". " if (self.publication_title_language.requires_transliteration && self.publication_title_transliteration.present?) || (!self.publication_title_language.requires_transliteration && self.publication_title_orig.present?) || (self.publication_title_language != english && self.publication_title_translation.present?)

    #editors
    s += "Edited by " + person_list(self.editors) + ". " if self.editors.count > 0

    #translators
    s += "Translated by " + person_list(self.translators) + ". " if self.translators.count > 0

    #edition
    s += self.edition + "ed. " if self.edition.present?

    #volume
    ### I AM HERE ###
  end

  def person_list people, are_editors=false, first_list=false,
    names = people.map_with_index{ |p, i| p.modern_source_display(i>0 || !first_list) }
    names = names.length > 3 ? names[0..2].join(', ') + ', et al.' : (names.length < 2 ? names[0] + '.' : names[0..-2].join(', ') + ", and " + names[-1] + '.')
    names += people.count > 1 ? ", eds." : ", ed." if are_editors
    names + " "
  end

end
