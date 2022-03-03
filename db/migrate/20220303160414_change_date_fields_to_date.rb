class ChangeDateFieldsToDate < ActiveRecord::Migration[7.0]
  def change
    remove_column :source_urls, :date_accessed
    add_column :source_urls, :date_accessed, :date
  end
end
