class CreateManuscriptUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :manuscript_urls do |t|
      t.references :manuscript, null: false, foreign_key: true
      t.string :url, null: false, default: ""
      t.integer :index
      t.timestamps
    end
  end
end
