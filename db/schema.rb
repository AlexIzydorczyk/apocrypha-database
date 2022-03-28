# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_03_28_170004) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "apocrypha", force: :cascade do |t|
    t.string "apocryphon_no", default: "", null: false
    t.string "cant_no", default: "", null: false
    t.string "bhl_no", default: "", null: false
    t.string "bhg_no", default: "", null: false
    t.string "bho_no", default: "", null: false
    t.string "e_clavis_no", default: "", null: false
    t.string "e_clavis_link", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "english_abbreviation", default: "", null: false
    t.bigint "main_english_title_id"
    t.bigint "main_latin_title_id"
    t.string "latin_abbreviation", default: "", null: false
    t.bigint "content_id"
    t.text "notes", default: "", null: false
    t.index ["content_id"], name: "index_apocrypha_on_content_id"
    t.index ["main_english_title_id"], name: "index_apocrypha_on_main_english_title_id"
    t.index ["main_latin_title_id"], name: "index_apocrypha_on_main_latin_title_id"
  end

  create_table "booklets", force: :cascade do |t|
    t.bigint "manuscript_id"
    t.string "booklet_no", default: "", null: false
    t.string "pages_folios_from", default: "", null: false
    t.string "date_from", default: "", null: false
    t.string "date_to", default: "", null: false
    t.string "specific_date", default: "", null: false
    t.bigint "genesis_location_id"
    t.bigint "genesis_institution_id"
    t.bigint "genesis_religious_order_id"
    t.string "content_type", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "pages_folios_to", default: "", null: false
    t.boolean "date_exact", default: true, null: false
    t.string "origin_notes", default: "", null: false
    t.index ["genesis_institution_id"], name: "index_booklets_on_genesis_institution_id"
    t.index ["genesis_location_id"], name: "index_booklets_on_genesis_location_id"
    t.index ["genesis_religious_order_id"], name: "index_booklets_on_genesis_religious_order_id"
    t.index ["manuscript_id"], name: "index_booklets_on_manuscript_id"
  end

  create_table "booklist_references", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "record_type"
    t.bigint "record_id"
    t.bigint "booklist_section_id"
    t.index ["booklist_section_id"], name: "index_booklist_references_on_booklist_section_id"
    t.index ["record_type", "record_id"], name: "index_booklist_references_on_record"
  end

  create_table "booklist_sections", force: :cascade do |t|
    t.bigint "booklist_id", null: false
    t.integer "sequence_no"
    t.string "heading_orig"
    t.string "heading_orig_transliteration"
    t.string "heading_translation"
    t.text "relevant_text_orig"
    t.text "relevant_text_orig_transliteration"
    t.text "relevant_text_translation"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "manuscript_id"
    t.bigint "modern_source_id"
    t.text "notes", default: "", null: false
    t.string "page_ref", default: "", null: false
    t.bigint "heading_language_id"
    t.bigint "relevant_text_language_id"
    t.index ["booklist_id"], name: "index_booklist_sections_on_booklist_id"
    t.index ["heading_language_id"], name: "index_booklist_sections_on_heading_language_id"
    t.index ["manuscript_id"], name: "index_booklist_sections_on_manuscript_id"
    t.index ["modern_source_id"], name: "index_booklist_sections_on_modern_source_id"
    t.index ["relevant_text_language_id"], name: "index_booklist_sections_on_relevant_text_language_id"
  end

  create_table "booklists", force: :cascade do |t|
    t.string "booklist_type", default: "", null: false
    t.string "manuscript_source", default: "", null: false
    t.bigint "library_owner_id"
    t.bigint "scribe_id"
    t.bigint "institution_id"
    t.bigint "location_id"
    t.bigint "religious_order_id"
    t.bigint "language_id"
    t.string "title_orig", default: "", null: false
    t.string "title_orig_transliteration", default: "", null: false
    t.string "title_orig_translation", default: "", null: false
    t.string "date_from", default: "", null: false
    t.string "date_to", default: "", null: false
    t.string "specific_date", default: "", null: false
    t.text "notes", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "booklist_no"
    t.boolean "date_exact", default: true, null: false
    t.bigint "title_language_id"
    t.index ["institution_id"], name: "index_booklists_on_institution_id"
    t.index ["language_id"], name: "index_booklists_on_language_id"
    t.index ["library_owner_id"], name: "index_booklists_on_library_owner_id"
    t.index ["location_id"], name: "index_booklists_on_location_id"
    t.index ["religious_order_id"], name: "index_booklists_on_religious_order_id"
    t.index ["scribe_id"], name: "index_booklists_on_scribe_id"
    t.index ["title_language_id"], name: "index_booklists_on_title_language_id"
  end

  create_table "change_logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "controller_name"
    t.string "action_name"
    t.string "record_type"
    t.bigint "record_id"
    t.string "additional_info", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id"], name: "index_change_logs_on_record"
    t.index ["user_id"], name: "index_change_logs_on_user_id"
  end

  create_table "contents", force: :cascade do |t|
    t.bigint "booklet_id"
    t.string "sequence_no", default: "", null: false
    t.bigint "title_id"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "manuscript_id"
    t.boolean "has_details", default: false, null: false
    t.index ["author_id"], name: "index_contents_on_author_id"
    t.index ["booklet_id"], name: "index_contents_on_booklet_id"
    t.index ["manuscript_id"], name: "index_contents_on_manuscript_id"
    t.index ["title_id"], name: "index_contents_on_title_id"
  end

  create_table "institutional_affiliations", force: :cascade do |t|
    t.bigint "institution_id", null: false
    t.bigint "religious_order_id"
    t.string "start_date", default: "", null: false
    t.string "end_date", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["institution_id"], name: "index_institutional_affiliations_on_institution_id"
    t.index ["religious_order_id"], name: "index_institutional_affiliations_on_religious_order_id"
  end

  create_table "institutions", force: :cascade do |t|
    t.string "name_english", default: "", null: false
    t.string "name_orig", default: "", null: false
    t.string "name_orig_transliteration", default: "", null: false
    t.bigint "location_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "writing_system_id"
    t.index ["location_id"], name: "index_institutions_on_location_id"
    t.index ["writing_system_id"], name: "index_institutions_on_writing_system_id"
  end

  create_table "language_references", force: :cascade do |t|
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "language_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["language_id"], name: "index_language_references_on_language_id"
    t.index ["record_type", "record_id"], name: "index_language_references_on_record"
  end

  create_table "languages", force: :cascade do |t|
    t.string "language_name", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "requires_transliteration", default: false, null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "country", default: "", null: false
    t.string "city_english", default: "", null: false
    t.string "city_orig", default: "", null: false
    t.string "city_translilteration", default: "", null: false
    t.string "region_english", default: "", null: false
    t.string "region_orig", default: "", null: false
    t.string "region_transliteration", default: "", null: false
    t.string "diocese_english", default: "", null: false
    t.string "diocese_orig", default: "", null: false
    t.string "diocese_transliteration", default: "", null: false
    t.integer "longitude"
    t.integer "latitude"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "city_orig_writing_system_id"
    t.bigint "region_orig_writing_system_id"
    t.bigint "diocese_orig_writing_system_id"
    t.index ["city_orig_writing_system_id"], name: "index_locations_on_city_orig_writing_system_id"
    t.index ["diocese_orig_writing_system_id"], name: "index_locations_on_diocese_orig_writing_system_id"
    t.index ["region_orig_writing_system_id"], name: "index_locations_on_region_orig_writing_system_id"
  end

  create_table "manuscripts", force: :cascade do |t|
    t.string "identifier", default: "", null: false
    t.string "census_no", default: "", null: false
    t.string "status", default: "", null: false
    t.bigint "institution_id"
    t.string "shelfmark", default: "", null: false
    t.string "old_shelfmark", default: "", null: false
    t.string "material", default: "", null: false
    t.string "dimensions", default: "", null: false
    t.string "leaf_page_no", default: "", null: false
    t.string "date_from", default: "", null: false
    t.string "date_to", default: "", null: false
    t.string "content_type", default: "", null: false
    t.text "notes", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "known_booklet_composition", default: true, null: false
    t.boolean "is_folios", default: true, null: false
    t.string "specific_date", default: "", null: false
    t.boolean "date_exact", default: true, null: false
    t.text "origin_notes"
    t.bigint "genesis_institution_id"
    t.bigint "genesis_religious_order_id"
    t.bigint "genesis_location_id"
    t.string "reproduction_online", default: "", null: false
    t.index ["genesis_institution_id"], name: "index_manuscripts_on_genesis_institution_id"
    t.index ["genesis_location_id"], name: "index_manuscripts_on_genesis_location_id"
    t.index ["genesis_religious_order_id"], name: "index_manuscripts_on_genesis_religious_order_id"
    t.index ["institution_id"], name: "index_manuscripts_on_institution_id"
  end

  create_table "modern_source_references", force: :cascade do |t|
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "modern_source_id"
    t.string "specific_page", default: "", null: false
    t.string "siglum", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "reference_type", default: "", null: false
    t.index ["modern_source_id"], name: "index_modern_source_references_on_modern_source_id"
    t.index ["record_type", "record_id"], name: "index_modern_source_references_on_record"
  end

  create_table "modern_sources", force: :cascade do |t|
    t.string "publication_title_orig", default: "", null: false
    t.string "publication_title_transliteration", default: "", null: false
    t.string "publication_title_translation", default: "", null: false
    t.string "title_orig", default: "", null: false
    t.string "title_transliteration", default: "", null: false
    t.string "title_translation", default: "", null: false
    t.string "source_type", default: "", null: false
    t.string "num_volumes", default: "", null: false
    t.string "volume_no", default: "", null: false
    t.string "volume_title_orig", default: "", null: false
    t.string "volume_title_transliteration", default: "", null: false
    t.string "volume_title_translation", default: "", null: false
    t.string "part_no", default: "", null: false
    t.string "part_title_orig", default: "", null: false
    t.string "part_title_transliteration", default: "", null: false
    t.string "part_title_translation", default: "", null: false
    t.string "series_no", default: "", null: false
    t.string "series_title_orig", default: "", null: false
    t.string "series_title_transliteration", default: "", null: false
    t.string "series_title_translation", default: "", null: false
    t.string "edition", default: "", null: false
    t.string "publisher", default: "", null: false
    t.string "publication_creation_date", default: "", null: false
    t.string "shelfmark", default: "", null: false
    t.string "ISBN", default: "", null: false
    t.string "DOI", default: "", null: false
    t.bigint "publication_location_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "author_type", default: "", null: false
    t.bigint "institution_id"
    t.bigint "publication_title_language_id"
    t.bigint "volume_title_language_id"
    t.bigint "part_title_language_id"
    t.bigint "series_title_language_id"
    t.bigint "title_language_id"
    t.string "pages_in_publication", default: "", null: false
    t.string "document_type", default: "", null: false
    t.string "date_accessed", default: "", null: false
    t.string "original_publication_creation_date", default: "", null: false
    t.string "old_id", default: "", null: false
    t.bigint "writing_system_id"
    t.string "display_name", default: "", null: false
    t.index ["institution_id"], name: "index_modern_sources_on_institution_id"
    t.index ["part_title_language_id"], name: "index_modern_sources_on_part_title_language_id"
    t.index ["publication_location_id"], name: "index_modern_sources_on_publication_location_id"
    t.index ["publication_title_language_id"], name: "index_modern_sources_on_publication_title_language_id"
    t.index ["series_title_language_id"], name: "index_modern_sources_on_series_title_language_id"
    t.index ["title_language_id"], name: "index_modern_sources_on_title_language_id"
    t.index ["volume_title_language_id"], name: "index_modern_sources_on_volume_title_language_id"
    t.index ["writing_system_id"], name: "index_modern_sources_on_writing_system_id"
  end

  create_table "ownerships", force: :cascade do |t|
    t.bigint "booklet_id"
    t.bigint "person_id"
    t.bigint "institution_id"
    t.bigint "location_id"
    t.bigint "religious_order_id"
    t.string "date_from", default: "", null: false
    t.string "date_to", default: "", null: false
    t.string "specific_date", default: "", null: false
    t.boolean "date_exact", default: true, null: false
    t.text "provenance_notes", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "manuscript_id"
    t.index ["booklet_id"], name: "index_ownerships_on_booklet_id"
    t.index ["institution_id"], name: "index_ownerships_on_institution_id"
    t.index ["location_id"], name: "index_ownerships_on_location_id"
    t.index ["manuscript_id"], name: "index_ownerships_on_manuscript_id"
    t.index ["person_id"], name: "index_ownerships_on_person_id"
    t.index ["religious_order_id"], name: "index_ownerships_on_religious_order_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "first_name_vernacular", default: "", null: false
    t.string "middle_name_vernacular", default: "", null: false
    t.string "last_name_vernacular", default: "", null: false
    t.string "first_name_english", default: "", null: false
    t.string "first_name_transliteration", default: "", null: false
    t.string "birth_date", default: "", null: false
    t.string "death_date", default: "", null: false
    t.string "character", default: "", null: false
    t.string "viaf", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "prefix_vernacular", default: "", null: false
    t.string "suffix_vernacular", default: "", null: false
    t.string "prefix_transliteration", default: "", null: false
    t.string "suffix_transliteration", default: "", null: false
    t.string "middle_name_transliteration", default: "", null: false
    t.string "last_name_transliteration", default: "", null: false
    t.string "prefix_english", default: "", null: false
    t.string "suffix_english", default: "", null: false
    t.string "middle_name_english", default: "", null: false
    t.string "last_name_english", default: "", null: false
    t.bigint "writing_system_id"
    t.boolean "birth_date_exact", default: true, null: false
    t.boolean "death_date_exact", default: true, null: false
    t.index ["writing_system_id"], name: "index_people_on_writing_system_id"
  end

  create_table "person_references", force: :cascade do |t|
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "person_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "reference_type", default: "", null: false
    t.index ["person_id"], name: "index_person_references_on_person_id"
    t.index ["record_type", "record_id"], name: "index_person_references_on_record"
  end

  create_table "religious_orders", force: :cascade do |t|
    t.string "order_name", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "abbreviation", default: "", null: false
    t.text "notes", default: "", null: false
  end

  create_table "sections", force: :cascade do |t|
    t.bigint "text_id", null: false
    t.string "section_name", default: "", null: false
    t.string "pages_folios_incipit", default: "", null: false
    t.string "incipit_orig", default: "", null: false
    t.string "incipit_orig_transliteration", default: "", null: false
    t.string "incipit_translation", default: "", null: false
    t.string "pages_folios_explicit", default: "", null: false
    t.string "explicit_orig", default: "", null: false
    t.string "explicitorig_transliteration", default: "", null: false
    t.string "explicit_translation", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "incipit_language_id"
    t.bigint "explicit_language_id"
    t.index ["explicit_language_id"], name: "index_sections_on_explicit_language_id"
    t.index ["incipit_language_id"], name: "index_sections_on_incipit_language_id"
    t.index ["text_id"], name: "index_sections_on_text_id"
  end

  create_table "source_urls", force: :cascade do |t|
    t.bigint "modern_source_id", null: false
    t.string "url", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "date_accessed"
    t.index ["modern_source_id"], name: "index_source_urls_on_modern_source_id"
  end

  create_table "text_urls", force: :cascade do |t|
    t.string "type", default: "", null: false
    t.bigint "text_id", null: false
    t.string "url", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["text_id"], name: "index_text_urls_on_text_id"
  end

  create_table "texts", force: :cascade do |t|
    t.bigint "content_id"
    t.string "text_pages_folios_from", default: "", null: false
    t.string "decoration", default: "", null: false
    t.string "title_pages_folios_from", default: "", null: false
    t.string "manuscript_title_orig", default: "", null: false
    t.string "manuscript_title_orig_transliteration", default: "", null: false
    t.string "manuscript_title_translation", default: "", null: false
    t.string "colophon_pages_folios_from", default: "", null: false
    t.string "colophon_orig", default: "", null: false
    t.string "colophon_transliteration", default: "", null: false
    t.string "colophon_translation", default: "", null: false
    t.text "notes", default: "", null: false
    t.bigint "transcriber_id"
    t.string "version", default: "", null: false
    t.string "extent", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "text_pages_folios_to", default: "", null: false
    t.string "title_pages_folios_to", default: "", null: false
    t.string "colophon_pages_folios_to", default: "", null: false
    t.string "date_to", default: "", null: false
    t.string "date_from", default: "", null: false
    t.boolean "date_exact", default: true, null: false
    t.string "specific_date", default: "", null: false
    t.string "no_columns", default: "", null: false
    t.string "script", default: "", null: false
    t.bigint "manuscript_title_language_id"
    t.bigint "colophon_language_id"
    t.bigint "writing_system_id"
    t.index ["colophon_language_id"], name: "index_texts_on_colophon_language_id"
    t.index ["content_id"], name: "index_texts_on_content_id"
    t.index ["manuscript_title_language_id"], name: "index_texts_on_manuscript_title_language_id"
    t.index ["transcriber_id"], name: "index_texts_on_transcriber_id"
    t.index ["writing_system_id"], name: "index_texts_on_writing_system_id"
  end

  create_table "titles", force: :cascade do |t|
    t.bigint "apocryphon_id"
    t.string "title_orig", default: "", null: false
    t.string "title_orig_transliteration", default: "", null: false
    t.string "title_translation", default: "", null: false
    t.bigint "language_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "italicized", default: false, null: false
    t.index ["apocryphon_id"], name: "index_titles_on_apocryphon_id"
    t.index ["language_id"], name: "index_titles_on_language_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: 6
    t.datetime "remember_created_at", precision: 6
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: 6
    t.datetime "last_sign_in_at", precision: 6
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: 6
    t.datetime "confirmation_sent_at", precision: 6
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "role", default: "new", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "writing_systems", force: :cascade do |t|
    t.string "name"
    t.boolean "requires_transliteration", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "apocrypha", "contents"
  add_foreign_key "apocrypha", "titles", column: "main_english_title_id"
  add_foreign_key "apocrypha", "titles", column: "main_latin_title_id"
  add_foreign_key "booklets", "institutions", column: "genesis_institution_id"
  add_foreign_key "booklets", "locations", column: "genesis_location_id"
  add_foreign_key "booklets", "manuscripts"
  add_foreign_key "booklets", "religious_orders", column: "genesis_religious_order_id"
  add_foreign_key "booklist_references", "booklist_sections"
  add_foreign_key "booklist_sections", "booklists"
  add_foreign_key "booklist_sections", "languages", column: "heading_language_id"
  add_foreign_key "booklist_sections", "languages", column: "relevant_text_language_id"
  add_foreign_key "booklist_sections", "manuscripts"
  add_foreign_key "booklist_sections", "modern_sources"
  add_foreign_key "booklists", "institutions"
  add_foreign_key "booklists", "languages"
  add_foreign_key "booklists", "languages", column: "title_language_id"
  add_foreign_key "booklists", "locations"
  add_foreign_key "booklists", "people", column: "library_owner_id"
  add_foreign_key "booklists", "people", column: "scribe_id"
  add_foreign_key "booklists", "religious_orders"
  add_foreign_key "change_logs", "users"
  add_foreign_key "contents", "booklets"
  add_foreign_key "contents", "manuscripts"
  add_foreign_key "contents", "people", column: "author_id"
  add_foreign_key "contents", "titles"
  add_foreign_key "institutional_affiliations", "institutions"
  add_foreign_key "institutional_affiliations", "religious_orders"
  add_foreign_key "institutions", "locations"
  add_foreign_key "language_references", "languages"
  add_foreign_key "locations", "writing_systems", column: "city_orig_writing_system_id"
  add_foreign_key "locations", "writing_systems", column: "diocese_orig_writing_system_id"
  add_foreign_key "locations", "writing_systems", column: "region_orig_writing_system_id"
  add_foreign_key "manuscripts", "institutions"
  add_foreign_key "manuscripts", "institutions", column: "genesis_institution_id"
  add_foreign_key "manuscripts", "locations", column: "genesis_location_id"
  add_foreign_key "manuscripts", "religious_orders", column: "genesis_religious_order_id"
  add_foreign_key "modern_source_references", "modern_sources"
  add_foreign_key "modern_sources", "institutions"
  add_foreign_key "modern_sources", "languages", column: "part_title_language_id"
  add_foreign_key "modern_sources", "languages", column: "publication_title_language_id"
  add_foreign_key "modern_sources", "languages", column: "series_title_language_id"
  add_foreign_key "modern_sources", "languages", column: "title_language_id"
  add_foreign_key "modern_sources", "languages", column: "volume_title_language_id"
  add_foreign_key "modern_sources", "locations", column: "publication_location_id"
  add_foreign_key "modern_sources", "writing_systems"
  add_foreign_key "ownerships", "booklets"
  add_foreign_key "ownerships", "institutions"
  add_foreign_key "ownerships", "locations"
  add_foreign_key "ownerships", "manuscripts"
  add_foreign_key "ownerships", "people"
  add_foreign_key "ownerships", "religious_orders"
  add_foreign_key "person_references", "people"
  add_foreign_key "sections", "languages", column: "explicit_language_id"
  add_foreign_key "sections", "languages", column: "incipit_language_id"
  add_foreign_key "sections", "texts"
  add_foreign_key "source_urls", "modern_sources"
  add_foreign_key "text_urls", "texts"
  add_foreign_key "texts", "contents"
  add_foreign_key "texts", "languages", column: "colophon_language_id"
  add_foreign_key "texts", "languages", column: "manuscript_title_language_id"
  add_foreign_key "texts", "people", column: "transcriber_id"
  add_foreign_key "texts", "writing_systems"
  add_foreign_key "titles", "apocrypha"
  add_foreign_key "titles", "languages"
end
