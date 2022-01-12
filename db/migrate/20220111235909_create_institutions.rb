class CreateInstitutions < ActiveRecord::Migration[7.0]
  def change
    create_table :institutions do |t|
      t.string :name_english, null: false, default: ""
      t.string :name_orig, null: false, default: ""
      t.string :name_orig_transliteration, null: false, default: ""
      t.references :location, foreign_key: true
      t.timestamps
    end
  end
end
