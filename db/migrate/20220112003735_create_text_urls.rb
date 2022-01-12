class CreateTextUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :text_urls do |t|
      t.string :type, null: false, default: ""
      t.references :text, null: false, foreign_key: true
      t.string :url, null: false, default: ""
      t.timestamps
    end
  end
end
