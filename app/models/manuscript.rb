class Manuscript < ApplicationRecord
  belongs_to :institution, optional: true
  has_many :language_references, as: :record
  # has_many :languages, through: :languages_references, as: :record
  has_many :booklets
  has_many :modern_source_references, as: :record
  has_many :modern_sources, through: :modern_source_references
  has_many :person_references
  has_many :correspondents, class_name: "Person", through: :person_references
  has_many :ownerships
  has_many :contents

  attr_writer :languages

  def languages=(value)
    puts 'inside attr writer'
    value.select{ |val| val.present? }.each{ |val|
      puts 'value'.blue
      puts val
      lr = LanguageReference.find_or_initilize_by(
        record: self,
        language_id: val,
      )
      lr.save!
    }
  end

end
