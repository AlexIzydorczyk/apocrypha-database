class CreateWritingSystems < ActiveRecord::Migration[7.0]
  def change
    create_table :writing_systems do |t|
      t.string :name
      t.boolean :requires_transliteration, null: false, default: false
      t.timestamps
    end
  end
end
