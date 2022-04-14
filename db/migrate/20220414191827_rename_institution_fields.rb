class RenameInstitutionFields < ActiveRecord::Migration[7.0]
  def change
    rename_column :institutions, :name_orig, :name
    rename_column :institutions, :name_english, :name_alt
    rename_column :institutions, :name_orig_transliteration, :name_transliteration
  end
end
