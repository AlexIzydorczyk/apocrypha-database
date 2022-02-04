class CreateBooklistSections < ActiveRecord::Migration[7.0]
  def change
    create_table :booklist_sections do |t|
      t.references :booklist, null: false, foreign_key: true
      t.integer :sequence_no
      t.string :heading_orig
      t.string :heading_orig_transliteration
      t.string :heading_translation
      t.text :relevant_text_orig
      t.text :relevant_text_orig_transliteration
      t.text :relevant_text_translation

      t.timestamps
    end
  end
end
