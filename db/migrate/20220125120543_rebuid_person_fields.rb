class RebuidPersonFields < ActiveRecord::Migration[7.0]
  def change
    add_column :people, :prefix_vernacular, :string, null: false, default: ""
    add_column :people, :suffix_vernacular, :string, null: false, default: ""
    rename_column :people, :first_name, :first_name_vernacular
    rename_column :people, :middle_name, :middle_name_vernacular
    rename_column :people, :last_name, :last_name_vernacular
    remove_column :people, :name_vernacular
    remove_column :people, :latin_name

    add_column :people, :prefix_transliteration, :string, null: false, default: ""
    add_column :people, :suffix_transliteration, :string, null: false, default: ""
    rename_column :people, :name_vernacular_transliteration, :first_name_transliteration
    add_column :people, :middle_name_transliteration, :string, null: false, default: ""
    add_column :people, :last_name_transliteration, :string, null: false, default: ""

    add_column :people, :prefix_english, :string, null: false, default: ""
    add_column :people, :suffix_english, :string, null: false, default: ""
    rename_column :people, :name_english, :first_name_english
    add_column :people, :middle_name_english, :string, null: false, default: ""
    add_column :people, :last_name_english, :string, null: false, default: ""
  end
end
