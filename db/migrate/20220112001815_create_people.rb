class CreatePeople < ActiveRecord::Migration[7.0]
  def change
    create_table :people do |t|
      t.string :first_name, null: false, default: ""
      t.string :middle_name, null: false, default: ""
      t.string :last_name, null: false, default: ""
      t.string :name_english, null: false, default: ""
      t.string :name_vernacular, null: false, default: ""
      t.string :name_vernacular_transliteration, null: false, default: ""
      t.string :latin_name, null: false, default: ""
      t.string :birth_date, null: false, default: ""
      t.string :death_date, null: false, default: ""
      t.string :character, null: false, default: ""
      t.string :viaf, null: false, default: ""
      t.timestamps
      # added language_id later
      # rebuild fields later to reflect '3 rows of fields' style translation/transliteration
    end
  end
end
