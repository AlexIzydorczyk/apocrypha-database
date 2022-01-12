class CreateTexts < ActiveRecord::Migration[7.0]
  def change
    create_table :texts do |t|
      t.references :content, foreign_key: true
      t.string :text_pages_folios, null: false, default: ""
      t.string :decoration, null: false, default: ""
      t.string :title_folios_pages, null: false, default: ""
      t.string :manuscript_title_orig, null: false, default: ""
      t.string :manuscript_title_orig_transliteration, null: false, default: ""
      t.string :manuscript_title_translation, null: false, default: ""
      t.string :pages_folios_colophon, null: false, default: ""
      t.string :colophon_orig, null: false, default: ""
      t.string :colophon_transliteration, null: false, default: ""
      t.string :colophon_translation, null: false, default: ""
      t.text :notes, null: false, default: ""
      t.references :transcriber, foreign_key: { to_table: :people }
      t.string :version, null: false, default: ""
      t.string :extent, null: false, default: ""
      t.timestamps
    end
  end
end
