class AddManuscriptToBooklistSection < ActiveRecord::Migration[7.0]
  def change
    add_reference :booklist_sections, :manuscript, foreign_key: true
  end
end
