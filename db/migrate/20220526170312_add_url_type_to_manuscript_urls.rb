class AddUrlTypeToManuscriptUrls < ActiveRecord::Migration[7.0]
  def change
    add_column :manuscript_urls, :url_type, :string, null: false, default: "database"
  end
end
