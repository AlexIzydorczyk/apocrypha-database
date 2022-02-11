class AddAccessedAtToModernSources < ActiveRecord::Migration[7.0]
  def change
    add_column :modern_sources, :date_accessed, :string, null: false, default: ""
  end
end
