class CreateBookletBooklists < ActiveRecord::Migration[7.0]
  def change
    create_table :booklet_booklists do |t|
      t.references :booklet, null: false, foreign_key: true
      t.references :booklist, null: false, foreign_key: true
      t.timestamps
    end
  end
end
