class CreateBooklistReferences < ActiveRecord::Migration[7.0]
  def change
    create_table :booklist_references do |t|
      t.references :booklist, null: false, foreign_key: true
      t.references :text, foreign_key: true
      t.references :apocryphon, foreign_key: true
      t.string :relevant_text_booklist_orig, null: false, default: ""
      t.string :relevant_text_booklist_orig_transliteration, null: false, default: ""
      t.string :relevant_text_booklist_translation, null: false, default: ""
      t.timestamps
    end
  end
end
