class CreateSourceUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :source_urls do |t|
      t.references :modern_source, null: false, foreign_key: true
      t.string :url, null: false, default: ""
      t.timestamps
    end
  end
end
