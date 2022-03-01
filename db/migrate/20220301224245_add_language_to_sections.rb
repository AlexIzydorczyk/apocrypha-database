class AddLanguageToSections < ActiveRecord::Migration[7.0]
  def change
    add_reference :sections, :incipit_language, foreign_key: { to_table: :languages }
    add_reference :sections, :explicit_language, foreign_key: { to_table: :languages }
  end
end
