class AddAbbreviationToApocrypha < ActiveRecord::Migration[7.0]
  def change
    add_column :apocrypha, :abbreviation, :string, null: false, default: ""
  end
end
