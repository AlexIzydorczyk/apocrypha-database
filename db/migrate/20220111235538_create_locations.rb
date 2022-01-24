class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.string :country, null: false, default: ""
      
      t.string :city_english, null: false, default: ""
      t.string :city_orig, null: false, default: ""
      t.string :city_translilteration, null: false, default: ""
      # later added - city_orig_language (reference)
      
      t.string :region_english, null: false, default: ""
      t.string :region_orig, null: false, default: ""
      t.string :region_transliteration, null: false, default: ""
      # later added - region_orig_language (reference)
      
      t.string :diocese_english, null: false, default: ""
      t.string :diocese_orig, null: false, default: ""
      t.string :diocese_transliteration, null: false, default: ""
      # later added - diocese_orig_language (reference)

      t.integer :longitude
      t.integer :latitude
      
      t.timestamps
    end
  end
end
