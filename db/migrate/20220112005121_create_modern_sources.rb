class CreateModernSources < ActiveRecord::Migration[7.0]
  def change
    create_table :modern_sources do |t|
      t.string :publication_title_orig, null: false, default: ""
      t.string :publication_title_transliteration, null: false, default: ""
      t.string :publication_title_translation, null: false, default: ""
      t.string :title_orig, null: false, default: ""
      t.string :title_transliteration, null: false, default: ""
      t.string :title_translation, null: false, default: ""
      t.string :source_type, null: false, default: ""
      t.string :num_volumes, null: false, default: ""
      t.string :volume_no, null: false, default: ""
      t.string :volume_title_orig, null: false, default: ""
      t.string :volume_title_transliteration, null: false, default: ""
      t.string :volume_title_translation, null: false, default: ""
      t.string :part_no, null: false, default: ""
      t.string :part_title_orig, null: false, default: ""
      t.string :part_title_transliteration, null: false, default: ""
      t.string :part_title_translation, null: false, default: ""
      t.string :series_no, null: false, default: ""
      t.string :series_title_orig, null: false, default: ""
      t.string :series_title_transliteration, null: false, default: ""
      t.string :series_title_translation, null: false, default: ""
      t.string :edition, null: false, default: ""
      t.string :publisher, null: false, default: ""
      t.string :publication_creation_date, null: false, default: ""
      t.string :shelfmark, null: false, default: ""
      t.string :ISBN, null: false, default: ""
      t.string :DOI, null: false, default: ""
      t.references :publication_location, foreign_key: { to_table: :locations }
      t.timestamps
    end
  end
end
