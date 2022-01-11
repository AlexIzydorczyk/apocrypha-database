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

ActiveRecord::Schema.define(version: 2021_12_31_153824) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "apocrypha", force: :cascade do |t|
    t.string "title", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "booklets", force: :cascade do |t|
    t.string "booklet_type", default: "", null: false
    t.bigint "manuscript_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "booklet_id"
    t.integer "booklet_num"
    t.integer "date_from"
    t.integer "date_to"
    t.string "specific_date", default: ""
    t.string "scribe_signature", default: ""
    t.string "scribe_name", default: ""
    t.text "scribe_notes", default: ""
    t.index ["manuscript_id"], name: "index_booklets_on_manuscript_id"
  end

  create_table "manuscripts", force: :cascade do |t|
    t.integer "manuscript_id", null: false
    t.string "status", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "city", default: ""
    t.string "country", default: ""
    t.string "repository", default: ""
    t.string "shelfmark", default: ""
    t.string "old_shelfmark", default: ""
    t.string "dimensions", default: ""
    t.string "num_pages", default: ""
    t.string "content_type", default: ""
    t.integer "date_from"
    t.integer "date_to"
    t.string "languages", default: [], array: true
  end

  create_table "sections", force: :cascade do |t|
    t.bigint "text_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title", default: ""
    t.string "folios_pages_implicit", default: ""
    t.string "implicit", default: ""
    t.string "folios_pages_explicit", default: ""
    t.string "explicit", default: ""
    t.index ["text_id"], name: "index_sections_on_text_id"
  end

  create_table "texts", force: :cascade do |t|
    t.string "parent_type"
    t.bigint "parent_id"
    t.bigint "apocryphon_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "text_id"
    t.string "folios_pages_text", default: ""
    t.string "decoration", default: ""
    t.string "folios_pages_title", default: ""
    t.string "title", default: ""
    t.string "folios_pages_colophon", default: ""
    t.string "colophon", default: ""
    t.text "notes", default: ""
    t.string "transcriptions_by", default: ""
    t.string "version", default: ""
    t.string "extent", default: ""
    t.string "online_reproduction", default: ""
    t.string "online_transcript", default: ""
    t.index ["apocryphon_id"], name: "index_texts_on_apocryphon_id"
    t.index ["parent_type", "parent_id"], name: "index_texts_on_parent"
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
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "booklets", "manuscripts"
  add_foreign_key "sections", "texts"
  add_foreign_key "texts", "apocrypha"
end
