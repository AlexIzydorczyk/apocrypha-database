class AddDateFieldsToTexts < ActiveRecord::Migration[7.0]
  def change
    add_column :texts, :date_to, :string, null: false, default: ""
    add_column :texts, :date_from, :string, null: false, default: ""
    add_column :texts, :date_exact, :boolean, null: false, default: true
    add_column :texts, :date, :string, null: false, default: ""
    add_column :texts, :no_columns, :string, null: false, default: ""
    add_column :texts, :script, :string, null: false, default: ""
    add_reference :texts, :manuscript_title_language, foreign_key: { to_table: :languages }
    add_reference :texts, :colophon_language, foreign_key: { to_table: :languages }
  end
end
