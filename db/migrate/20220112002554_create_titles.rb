class CreateTitles < ActiveRecord::Migration[7.0]
  def change
    create_table :titles do |t|
      t.references :apocryphon, foreign_key: true
      t.string :title_orig, null: false, default: ""
      t.string :title_orig_transliteration, null: false, default: ""
      t.string :title_translation, null: false, default: ""
      t.references :language, foreign_key: true
      t.timestamps
    end
  end
end
