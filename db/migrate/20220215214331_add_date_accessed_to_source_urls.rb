class AddDateAccessedToSourceUrls < ActiveRecord::Migration[7.0]
  def change
    add_column :source_urls, :date_accessed, :string, null: false, default: ""
  end
end
