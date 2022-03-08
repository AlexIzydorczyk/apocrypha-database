class ModernSource < ApplicationRecord
  belongs_to :publication_location, class_name: "Location", optional: true
  belongs_to :language, optional: true
  belongs_to :institution, optional: true
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
    s = ""
    
    # name (initial)
    if self.author_type == 'corporate'
      s += self.institution.display_name + " " if self.institution.present?
    elsif self.authors.count > 0
      s += person_list(self.authors, false, true) + " "
    elsif self.editors.count > 0
      s += person_list(self.editors, true, true) + " "
    end

    # title
    s += title(self.title_language, self.title_orig, self.title_transliteration, self.title_transliteration, true) + ". " if ['book_chapter', 'journal_article'].include?(self.source_type)

    # publication title
    s += title(self.publication_title_language, self.publication_title_orig, self.publication_title_transliteration, self.publication_title_transliteration, false, true) + ". "

    #editors
    s += "Edited by " + person_list(self.editors) + ". " if self.editors.count > 0

    #translators
    s += "Translated by " + person_list(self.translators) + ". " if self.translators.count > 0

    #edition
    s += self.edition + "ed. " if self.edition.present?

    #volume
    if self.volume_no.present? || self.volume_title_orig.present? || self.volume_title_transliteration.present? || self.volume_title_translation.present?
      s += "Vol. "
      s += [
        self.volume_no,
        title(self.volume_title_language, self.volume_title_orig, self.volume_title_transliteration, self.volume_title_translation)
      ].select{ |v| v.present? }.join(", ") + ". "
    end

    #part
    if self.part_no.present? || self.part_title_orig.present? || self.part_title_transliteration.present? || self.part_title_translation.present?
      s += "Pt. "
      s += [
        self.part_no,
        title(self.part_title_language, self.part_title_orig, self.part_title_transliteration, self.part_title_translation, false, true)
      ].select{ |v| v.present? }.join(", ") + ". "
    end

    #num volumes
    s += self.num_volumes + " vols. " if self.num_volumes.present?

    #series and pages
    if self.series_no.present? || self.series_title_orig.present? || self.series_title_transliteration.present? || self.series_title_translation.present? || self.pages_in_publication.present?
      
      s += [
        [
          title(self.series_title_language, self.series_title_orig, self.series_title_transliteration, self.series_title_translation),
          self.series_no + (source_type == 'unpublished_document' && self.publication_creation_date.present? ? (" (" + self.publication_creation_date + ")") : "")
        ].select{ |v| v.present? }.join(" "),
        ['book_chapter', 'journal_article'].include?(self.source_type) && self.pages_in_publication.present? ? ("pp. " + self.pages_in_publication) : ""
      ].select{ |b| b.present? }.join(", ") + ". "
    end

    #publication
    unless self.source_type == "unpublished_document"
      pub = [
        self.document_type,
        self.original_publication_creation_date.present? ? (self.original_publication_creation_date + ". Reprint") : "",
        [
          self.publication_location.try(:city_region_country),
          self.publisher
        ].select{ |v| v.present? }.join(": "),
        self.publication_creation_date.present? ? (self.source_type == 'web_page' ? "Last modified " : "") + self.publication_creation_date : "",
        self.institution.present? ? self.institution.display_name : "",
        self.shelfmark.present? ? ("MS " + self.shelfmark) : "",
      ].select{ |b| b.present? }.join(", ") + ". "
      s += pub + ". " if pub.present?
    end

    #shelfmark


    #first url
    self.source_urls.each_with_index do |source, source_index|
      if source.url.present?
        s += "Accssed " if source_index == 0 if source.date_accessed.present?
        s += source.date_accessed.strftime("%-d %B, %Y") + ". " if source.date_accessed.present?
        s += source.url + ". "
      end
    end

    #doi
    s += "doi: " + self.DOI + ". " if self.DOI.present?

    s.strip.gsub("  ", " ").gsub(" .", ".").gsub("...", ".").gsub("..", ".").html_safe
  end

  def person_list people, are_editors=false, first_list=false,
    names = people.map.with_index{ |p, i| p.modern_source_display(i>0 || !first_list) }
    names = names.length > 3 ? names[0..2].join(', ') + ', et al.' : (names.length < 2 ? names[0] + '.' : names[0..-2].join(', ') + ", and " + names[-1] + '.')
    names += people.count > 1 ? ", eds." : ", ed." if are_editors
    names + " "
  end

  def title language, orig, translit, transla, show_quotes=false, italics=false
    s = ""
    title = language.present? && language.requires_transliteration ? translit : orig
    if title.present?
      s += '"' if show_quotes
      s += "<i>" if italics
      s += title
      s += "</i>" if italics
      s = '"' if show_quotes
      s += " "
    end
    english = Language.find_or_create_by(language_name: 'English', requires_transliteration: false)
    s += "[" + transla + "]" unless language == english || transla.blank?
    s
  end

end
