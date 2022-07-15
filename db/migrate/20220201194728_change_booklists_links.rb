class ChangeBooklistsLinks < ActiveRecord::Migration[7.0]
  def change
    remove_column :booklists, :chapter_orig, :string
    remove_column :booklists, :chapter_orig_transliteration, :string
    remove_column :booklists, :chapter_translation, :string
    add_column :booklists, :booklist_no, :string

    add_reference :booklist_references, :record, polymorphic: true
    add_reference :booklist_references, :booklist_section, foreign_key: true
    remove_reference :booklist_references, :apocryphon, foreign_key: true
    remove_reference :booklist_references, :booklist, foreign_key: true
    remove_reference :booklist_references, :text, foreign_key: true
    remove_column :booklist_references, :relevant_text_booklist_orig, :string
    remove_column :booklist_references, :relevant_text_booklist_orig_transliteration, :string
    remove_column :booklist_references, :relevant_text_booklist_translation, :string
  end
end
