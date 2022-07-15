class Text < ApplicationRecord
  belongs_to :content
  belongs_to :transcriber, class_name: "Person", optional: true
  has_many :language_references, as: :record
  has_many :languages, through: :language_references, as: :record
  has_many :text_urls
  has_many :booklist_references
  has_many :booklists, through: :booklist_references
  has_many :sections, -> { order("index ASC") }, dependent: :destroy
  has_many :modern_source_references, as: :record
  has_many :person_references
  has_many :scribes, as: "Person", through: :person_references
  has_many :inventoried, -> { where(reference_type: "inventoried") }, as: :record, class_name: "ModernSourceReference"
  has_many :edition_by, -> { where(reference_type: "edition_by") }, as: :record, class_name: "ModernSourceReference"
  belongs_to :writing_system, optional: true
  has_many :person_references, as: :record, dependent: :destroy
  has_many :scribe_references, -> { scribe }, class_name: "PersonReference", as: :record, dependent: :destroy
  has_many :scribes, through: :scribe_references, source: :person

  before_create :set_default_writing_system

  def set_default_writing_system
    ws = WritingSystem.find_by(name: 'Latin')
    self.writing_system = ws if ws.present?
  end

  def find_manuscript
    self.content.parent.class == Manuscript ? self.content.parent : self.content.parent.manuscript
  end
end
