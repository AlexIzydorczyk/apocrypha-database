class AddOldIdToModernSources < ActiveRecord::Migration[7.0]
  def change
    add_column :modern_sources, :old_id, :string, null: false, default: ""
  end
end
