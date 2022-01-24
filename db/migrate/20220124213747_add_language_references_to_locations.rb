class AddLanguageReferencesToLocations < ActiveRecord::Migration[7.0]
  def change
    add_reference :locations, :city_orig_language, foreign_key: { to_table: :languages }
    add_reference :locations, :region_orig_language, foreign_key: { to_table: :languages }
    add_reference :locations, :diocese_orig_language, foreign_key: { to_table: :languages }
  end
end
