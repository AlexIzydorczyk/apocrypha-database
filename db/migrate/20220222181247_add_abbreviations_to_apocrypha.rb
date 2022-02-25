class AddAbbreviationsToApocrypha < ActiveRecord::Migration[7.0]
  def change
    add_column :apocrypha, :latin_abbreviation, :string, null: false, default: ""
    rename_column :apocrypha, :abbreviation, :english_abbreviation
  end
end
