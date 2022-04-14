class RenameCityFields < ActiveRecord::Migration[7.0]
  def change
    rename_column :locations, :city_orig, :city
    rename_column :locations, :city_english, :city_alt
    rename_column :locations, :city_orig_writing_system_id, :city_writing_system_id
    rename_column :locations, :diocese_orig, :diocese
    rename_column :locations, :diocese_english, :diocese_alt
    rename_column :locations, :diocese_orig_writing_system_id, :diocese_writing_system_id
    rename_column :locations, :region_orig, :region
    rename_column :locations, :region_english, :region_alt
    rename_column :locations, :region_orig_writing_system_id, :region_writing_system_id
  end
end
