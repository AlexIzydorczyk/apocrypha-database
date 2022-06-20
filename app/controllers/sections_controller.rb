class SectionsController < ApplicationController
  before_action :set_section, only: %i[ show edit update destroy ]
  skip_before_action :authenticate_user!, only: %i[ index ]
  before_action :allow_for_editor, only: %i[ edit update destroy create ]

 def index

    @grid_states = UserGridState.where(user_id: nil, record_type: "Section").order(:index)

    ugs = user_signed_in? && current_user.user_grid_states.exists?(record_type: "Section") ? current_user.user_grid_states.where(record_type: "Section").first : (UserGridState.exists?(record_type: "Section", is_default: true) ? UserGridState.where(record_type: "Section", is_default: true).first : nil)

    @initial_state = ugs.try(:state).try(:to_json).try(:html_safe)
    @initial_filter = ugs.try(:filters).try(:to_json).try(:html_safe)

    @query = ActiveRecord::Base.connection.execute("

SELECT DISTINCT

sections.section_name AS section_name,
sections.index + 1 AS section_number, -- special
sections.pages_folios_incipit AS section_pages_folios_incipit,
sections.incipit_orig AS section_incipit_orig,
sections.incipit_translation AS section_incipit_orig_translation,
sections.incipit_orig_transliteration AS section_incipit_orig_transliteration,
sections.pages_folios_explicit AS section_pages_folios_explicit,
sections.explicit_orig AS section_explicit_orig,
sections.explicitorig_transliteration AS section_explicitorig_transliteration,
sections.explicit_translation AS section_explicit_translation,

texts.text_pages_folios_to AS text_text_pages_folios_to,
texts.decoration AS text_decoration,
texts.title_pages_folios_to AS text_title_pages_folios,
texts.manuscript_title_orig AS text_manuscript_title_orig,
texts.manuscript_title_orig_transliteration AS text_manuscript_title_orig_transliteration,
texts.manuscript_title_translation AS text_manuscript_title_translation,
texts.colophon_pages_folios_to AS text_colophon_pages_folios_to,
texts.colophon_orig AS text_colophon_orig,
texts.colophon_transliteration AS text_colophon_transliteration,
texts.colophon_translation AS text_colophon_translation,
texts.notes AS text_notes,
texts.version AS text_version,
texts.extent AS text_extent,
ARRAY_TO_STRING(ARRAY_REMOVE(ARRAY_AGG(DISTINCT text_language.language_name), NULL), ', ') AS text_language, -- special
texts.date_from AS text_date_from,
texts.date_to AS text_date_to,
CONCAT((CASE WHEN texts.date_exact AND texts.specific_date != '' THEN 'ca. ' ELSE '' END), texts.specific_date) AS text_specific_date, -- special
texts.no_columns AS text_no_columns,
ARRAY_TO_STRING(ARRAY_REMOVE(ARRAY_AGG(DISTINCT CONCAT_WS(' ', nullif(trim(text_scribes.first_name_vernacular), ''), nullif(trim(text_scribes.middle_name_vernacular), ''), nullif(trim(text_scribes.prefix_vernacular), ''), nullif(trim(text_scribes.last_name_vernacular), ''), nullif(trim(text_scribes.suffix_vernacular), ''))), NULL), ', ') AS text_scribes, -- special
texts.script AS text_script,
texts.notes_on_scribe AS text_notes_on_scribe,

content_title.id,
contents.sequence_no AS content_sequence_no,
ARRAY_TO_STRING(ARRAY_REMOVE(ARRAY_AGG(DISTINCT CONCAT_WS(', ',
  nullif(trim(content_title.title_orig), ''),
  nullif(trim(CONCAT_WS(' ',
    nullif(trim(content_author.first_name_vernacular), ''),
    nullif(trim(content_author.middle_name_vernacular), ''),
    nullif(trim(content_author.prefix_vernacular), ''),
    nullif(trim(content_author.last_name_vernacular), ''),
    nullif(trim(content_author.suffix_vernacular), '')
  )), '')
)), NULL), ', ') AS content_item,
CASE WHEN content_title.apocryphon_id is null THEN 'Non apocryphal' ELSE 'Apocryphal' END AS content_apocryphal,
ARRAY_TO_STRING(ARRAY_REMOVE(ARRAY_AGG(DISTINCT main_eng_title.title_orig), NULL), ', ') AS apocryphon_main_english_title,
ARRAY_TO_STRING(ARRAY_REMOVE(ARRAY_AGG(DISTINCT other_eng_titles.title_orig), NULL), ', ') AS apocryphon_other_english_titles,
ARRAY_TO_STRING(ARRAY_REMOVE(ARRAY_AGG(DISTINCT main_latin_title.title_orig), NULL), ', ') AS apocryphon_main_latin_title,
ARRAY_TO_STRING(ARRAY_REMOVE(ARRAY_AGG(DISTINCT other_latin_titles.title_orig), NULL), ', ') AS apocryphon_other_latin_titles,
ARRAY_TO_STRING(ARRAY_REMOVE(ARRAY_CAT(ARRAY_AGG(DISTINCT main_eng_title.title_orig), ARRAY_AGG(DISTINCT other_eng_titles.title_orig)), NULL), ', ') AS apocryphon_all_english_titles,
ARRAY_TO_STRING(ARRAY_REMOVE(ARRAY_CAT(ARRAY_AGG(DISTINCT main_latin_title.title_orig), ARRAY_AGG(DISTINCT other_latin_titles.title_orig)), NULL), ', ') AS apocryphon_all_latin_titles,
apocrypha.e_clavis_link AS apocryphon_e_clavis_link,

booklets.booklet_no AS booklet_no,
booklets.pages_folios_from AS booklet_pages_folios_from,
booklets.pages_folios_to AS booklet_pages_folios_to,
booklets.date_from AS booklet_date_from,
booklets.date_to AS booklet_date_to,
CONCAT((CASE WHEN booklets.date_exact AND booklets.specific_date != '' THEN 'ca. ' ELSE '' END), booklets.specific_date) AS booklet_specific_date, -- special
booklets.content_type AS booklet_content_type,

CONCAT('/manuscripts/', CAST(manuscripts.id AS varchar)) AS manuscript_show_link,
ARRAY_TO_STRING(ARRAY_REMOVE(ARRAY_AGG(DISTINCT reproduction_urls.url), NULL), ', ') AS manuscript_reproduction_online,
ARRAY_TO_STRING(ARRAY_REMOVE(ARRAY_AGG(DISTINCT database_urls.url), NULL), ', ') AS manuscript_urls,
manuscripts.census_no AS manuscript_census_no,
manuscripts.status AS manuscript_status,
STRING_AGG(nullif(trim(repository.name), ''), (CASE WHEN repository.name_alt != '' THEN CONCAT('[', repository.name_alt, ']') ELSE '' END)) AS manuscript_institution_name,
repository.name_alt AS manuscript_institution_name_alternative,
repository_location.city AS manuscript_institution_city,
repository_location.city_alt AS manuscript_institution_city_alt,
CONCAT_WS(', ', nullif(trim(repository_location.city), ''), nullif(trim(repository_location.city_alt), '')) AS manuscript_institution_city_concat,
repository_location.region AS manuscript_institution_region,
repository_location.region_alt AS manuscript_institution_region_alt,
CONCAT_WS(', ', nullif(trim(repository_location.region), ''), nullif(trim(repository_location.region_alt), '')) AS manuscript_institution_region_concat,
repository_location.country AS manuscript_institution_country,
repository_location.diocese AS manuscript_institution_diocese,
repository_location.diocese_alt AS manuscript_institution_diocese_alt,
CONCAT_WS(', ', nullif(trim(repository_location.diocese), ''), nullif(trim(repository_location.diocese_alt), '')) AS manuscript_institution_diocese_concat,
manuscripts.shelfmark AS manuscript_shelfmark,
manuscripts.old_shelfmark AS manuscript_old_shelfmark,
manuscripts.material AS manuscript_material,
manuscripts.dimensions AS manuscript_dimensions,
CASE WHEN manuscripts.leaf_page_no = '' THEN '' ELSE CONCAT(manuscripts.leaf_page_no, (CASE WHEN manuscripts.is_folios THEN ' ff.' ELSE ' pp.' END)) END AS manuscript_leaf_page_no,
manuscripts.date_from AS manuscript_date_from,
manuscripts.date_to AS manuscript_date_to,
CONCAT((CASE WHEN manuscripts.date_exact AND manuscripts.specific_date != '' THEN 'ca. ' ELSE '' END), manuscripts.specific_date) AS manuscript_specific_date, -- special
manuscripts.content_type AS manuscript_content_type,
manuscripts.notes AS manuscript_notes,
ARRAY_TO_STRING(ARRAY_REMOVE(ARRAY_AGG(DISTINCT manuscript_languages.language_name), NULL), ', ') AS manuscript_languages, -- special
CONCAT(manuscripts.census_no, (CASE WHEN manuscripts.census_no = '' THEN '' ELSE '. ' END), CONCAT_WS(', ',
  CONCAT((CASE WHEN manuscripts.status in ('lost', 'destroyed') THEN '*' ELSE '' END), repository_location.city),
  nullif(trim(repository_location.country), ''),
  CONCAT(nullif(trim(repository.name), ''), (CASE WHEN repository.name_alt != '' THEN CONCAT(' [', repository.name_alt, ']') ELSE '' END)),
  nullif(trim(manuscripts.shelfmark), '')
)) AS manuscript_identification,

genesis_institution.name AS genesis_institution_name,
genesis_institution.name_alt AS genesis_institution_name_alt,
CONCAT_WS(', ', nullif(trim(genesis_institution.name), ''), nullif(trim(genesis_institution.name_alt), '')) AS genesis_institution_name_concat,
genesis_religious_order.order_name AS genesis_religious_order_name,
genesis_religious_order.abbreviation AS genesis_religious_order_abbrev,
genesis_location.city AS genesis_location_city,
genesis_location.city_alt AS genesis_location_city_alt,
CONCAT_WS(', ', nullif(trim(genesis_location.city), ''), nullif(trim(genesis_location.city_alt), '')) AS genesis_location_city_concat,
genesis_location.region AS genesis_location_region,
genesis_location.region_alt AS genesis_location_region_alt,
CONCAT_WS(', ', nullif(trim(genesis_location.region), ''), nullif(trim(genesis_location.region_alt), '')) AS genesis_location_region_concat,
genesis_location.diocese AS genesis_location_diocese,
genesis_location.diocese_alt AS genesis_location_diocese_alt,
CONCAT_WS(', ', nullif(trim(genesis_location.diocese), ''), nullif(trim(genesis_location.diocese_alt), '')) AS genesis_location_diocese_concat,
genesis_location.country AS genesis_location_country,
CASE WHEN booklets.id is null THEN manuscripts.origin_notes ELSE booklets.origin_notes END AS genesis_origin_notes,
ARRAY_TO_STRING(ARRAY_REMOVE(ARRAY_AGG(DISTINCT CONCAT_WS('. ',
  nullif(trim(CONCAT_WS('; ',
    nullif(trim(CONCAT_WS(', ',
      nullif(trim(CONCAT_WS(' ',
        nullif(trim(CONCAT_WS(' ',
          nullif(trim(provenance_person.first_name_vernacular), ''),
          nullif(trim(provenance_person.middle_name_vernacular), ''),
          nullif(trim(provenance_person.prefix_vernacular), ''),
          nullif(trim(provenance_person.last_name_vernacular), ''),
          nullif(trim(provenance_person.suffix_vernacular), '')
        )), ''),
        CASE WHEN provenance_person.birth_date != '' AND provenance_person.death_date != '' THEN CONCAT('(', provenance_person.birth_date, ' - ', provenance_person.death_date, ')') ELSE null END
      )), ''),
    CONCAT(nullif(trim(provenance_institution.name), ''), (CASE WHEN provenance_institution.name_alt != '' THEN CONCAT('[', provenance_institution.name_alt, ']') ELSE null END)),
    nullif(trim(provenance_religious_order.order_name), '')
  )), ''),
  nullif(trim(CONCAT_WS(', ',
    nullif(trim(provenance_location.city), ''),
    (CASE WHEN provenance_location.diocese != '' THEN CONCAT('dioc. ', provenance_location.diocese) ELSE null END),
    nullif(trim(provenance_location.region), ''),
    nullif(trim(provenance_location.country), '')
    )), '')
  )), ''),
  provenance.provenance_notes
  )
), NULL), ' || ') AS ownerships,
CONCAT_WS('. ',
  nullif(trim(CONCAT_WS(', ',
    nullif(trim(genesis_institution.name), ''),
    nullif(trim(genesis_religious_order.order_name), ''),
    nullif(trim(genesis_location.city), ''),
    nullif(trim(genesis_location.diocese), ''),
    nullif(trim(genesis_location.region), ''),
    nullif(trim(genesis_location.country), '')
  )), ''),
  nullif(trim(CASE WHEN booklets.id is null THEN manuscripts.origin_notes ELSE booklets.origin_notes END), '')
) AS genesis_full_description
    
FROM manuscripts
                                                   
FULL JOIN booklets ON manuscripts.id = booklets.manuscript_id
LEFT JOIN contents ON contents.booklet_id = booklets.id OR contents.manuscript_id = manuscripts.id
FULL JOIN texts ON contents.id = texts.content_id
FULL JOIN sections ON texts.id = sections.text_id

LEFT JOIN language_references manuscript_language_references ON manuscript_language_references.record_type = 'Manuscript' AND manuscript_language_references.record_id = manuscripts.id
LEFT JOIN languages manuscript_languages ON manuscript_languages.id = manuscript_language_references.language_id
LEFT JOIN manuscript_urls reproduction_urls ON reproduction_urls.url_type = 'reproduction' AND manuscripts.id = reproduction_urls.manuscript_id
LEFT JOIN manuscript_urls database_urls ON database_urls.url_type = 'database' AND manuscripts.id = database_urls.manuscript_id
LEFT JOIN institutions repository ON manuscripts.institution_id = repository.id
LEFT JOIN locations repository_location ON repository.location_id = repository_location.id
LEFT JOIN institutions genesis_institution ON CASE WHEN booklets.id is null THEN manuscripts.genesis_institution_id = genesis_institution.id ELSE booklets.genesis_institution_id = genesis_institution.id END
LEFT JOIN religious_orders genesis_religious_order ON CASE WHEN booklets.id is null THEN manuscripts.genesis_religious_order_id = genesis_religious_order.id ELSE booklets.genesis_religious_order_id = genesis_religious_order.id END
LEFT JOIN locations genesis_location ON CASE WHEN booklets.id is null THEN manuscripts.genesis_location_id = genesis_location.id ELSE booklets.genesis_location_id = genesis_location.id END
LEFT JOIN ownerships provenance ON CASE WHEN booklets.id is null THEN manuscripts.id = provenance.manuscript_id ELSE booklets.id = provenance.booklet_id END
LEFT JOIN people provenance_person ON provenance.person_id = provenance_person.id
LEFT JOIN institutions provenance_institution ON provenance.institution_id = provenance_institution.id
LEFT JOIN religious_orders provenance_religious_order ON provenance.religious_order_id = provenance_religious_order.id
LEFT JOIN locations provenance_location ON provenance.location_id = provenance_location.id
LEFT JOIN people content_author ON contents.author_id = content_author.id
LEFT JOIN titles content_title ON contents.title_id = content_title.id
LEFT JOIN apocrypha ON content_title.apocryphon_id = apocrypha.id
LEFT JOIN titles main_eng_title ON main_eng_title.id = apocrypha.main_english_title_id
LEFT JOIN titles main_latin_title ON main_latin_title.id = apocrypha.main_latin_title_id
LEFT JOIN languages english ON english.language_name = 'English'
LEFT JOIN languages latin ON latin.language_name = 'Latin'
LEFT JOIN titles other_eng_titles ON apocrypha.id = other_eng_titles.apocryphon_id AND other_eng_titles.language_id = english.id AND other_eng_titles.id != main_eng_title.id
LEFT JOIN titles other_latin_titles ON apocrypha.id = other_latin_titles.apocryphon_id AND other_latin_titles.language_id = latin.id AND other_latin_titles.id != main_latin_title.id
LEFT JOIN language_references text_language_references ON text_language_references.record_type = 'Text' AND text_language_references.record_id = texts.id
LEFT JOIN languages text_language ON text_language.id = text_language_references.language_id
LEFT JOIN person_references text_scribe_references ON text_scribe_references.record_type = 'Text' AND text_scribe_references.reference_type = 'scribe' AND text_scribe_references.record_id = texts.id
LEFT JOIN people text_scribes ON text_scribes.id = text_scribe_references.person_id

GROUP BY
manuscripts.id,
booklets.id,
content_title.id,
texts.id,
contents.id,
sections.id,
apocrypha.id,
repository_location.id,
repository.id,
genesis_institution.id,
genesis_religious_order.id,
text_language.id,
genesis_location.id;

")

  end

  def show
  end

  def new
    @section = Section.new
  end

  def edit
  end

  def create
    @section = Section.new(section_params)

    if @section.save
      ChangeLog.create(user_id: current_user.id, record_type: 'Section', record_id: @section.id, controller_name: 'section', action_name: 'create')
      redirect_url = @section.text.content.booklet.present? ? edit_manuscript_booklet_content_text_path(@section.text.content.booklet.manuscript, @section.text.content.booklet, @section.text.content, @section.text) : edit_manuscript_content_text_path(@section.text.content.manuscript, @section.text.content, @section.text)
      redirect_to redirect_url, notice: "Section was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @section.update(section_params)
      ChangeLog.create(user_id: current_user.id, record_type: 'Section', record_id: @section.id, controller_name: 'section', action_name: 'update')
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to sections_url, notice: "Section was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @section.destroy
    ChangeLog.create(user_id: current_user.id, record_type: 'Section', record_id: @section.id, controller_name: 'section', action_name: 'destroy')
    redirect_to sections_url, notice: "Section was successfully destroyed." unless request.xhr?
  end

  private
    def set_section
      @section = Section.find(params[:id])
    end

    def section_params
      params.require(:section).permit(:text_id, :section_name, :pages_folios_incipit, :incipit_orig, :incipit_orig_transliteration, :incipit_translation, :pages_folios_explicit, :explicit_orig, :explicitorig_transliteration, :explicit_translation)
    end
end
