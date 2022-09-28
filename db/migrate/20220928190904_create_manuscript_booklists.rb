class CreateManuscriptBooklists < ActiveRecord::Migration[7.0]
  def change
    create_table :manuscript_booklists do |t|
      t.references :manuscript, null: false, foreign_key: true
      t.references :booklist, null: false, foreign_key: true
      t.timestamps
    end
  end
end
