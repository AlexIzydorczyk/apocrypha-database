class CreateSections < ActiveRecord::Migration[7.0]
  def change
    create_table :sections do |t|
      t.references :text, null: false, foreign_key: true
      t.string :section_name, null: false, default: ""
      t.string :pages_folios_incipit, null: false, default: ""
      t.string :incipit_orig, null: false, default: ""
      t.string :incipit_orig_transliteration, null: false, default: ""
      t.string :incipit_translation, null: false, default: ""
      t.string :pages_folios_explicit, null: false, default: ""
      t.string :explicit_orig, null: false, default: ""
      t.string :explicitorig_transliteration, null: false, default: ""
      t.string :explicit_translation, null: false, default: ""
      t.timestamps
    end
  end
end
