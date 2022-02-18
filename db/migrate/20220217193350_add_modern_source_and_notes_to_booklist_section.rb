class AddModernSourceAndNotesToBooklistSection < ActiveRecord::Migration[7.0]
  def change
    add_reference :booklist_sections, :modern_source, foreign_key: true
    add_column :booklist_sections, :notes, :text, null: false, default: ""
    add_column :booklist_sections, :page_ref, :string, null: false, default: ""
  end
end
