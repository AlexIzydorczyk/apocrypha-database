class CreateBooklists < ActiveRecord::Migration[7.0]
  def change
    create_table :booklists do |t|
      t.string :booklist_type, null: false, default: ""
      t.string :manuscript_source, null: false, default: ""
      t.references :library_owner
      t.references :scribe
      t.references :institution, foreign_key: true
      t.references :location, foreign_key: true
      t.references :religious_order, foreign_key: true
      t.references :language, foreign_key: true
      t.string :title_orig, null: false, default: ""
      t.string :title_orig_transliteration, null: false, default: ""
      t.string :title_orig_translation, null: false, default: ""
      t.string :chapter_orig, null: false, default: ""
      t.string :chapter_orig_transliteration, null: false, default: ""
      t.string :chapter_translation, null: false, default: ""
      t.string :date_from, null: false, default: ""
      t.string :date_to, null: false, default: ""
      t.string :specific_date, null: false, default: ""
      t.text :notes, null: false, default: ""
      t.timestamps
    end
    add_foreign_key :booklists, :people, column: :library_owner_id, primary_key: :id
    add_foreign_key :booklists, :people, column: :scribe_id, primary_key: :id
  end
end
