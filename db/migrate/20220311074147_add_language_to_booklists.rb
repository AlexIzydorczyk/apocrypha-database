class AddLanguageToBooklists < ActiveRecord::Migration[7.0]
  def change
    add_reference :booklist_sections, :heading_language, foreign_key: { to_table: :languages }
    add_reference :booklists, :title_language, foreign_key: { to_table: :languages }
    add_reference :booklist_sections, :relevant_text_language, foreign_key: { to_table: :languages }
  end
end
