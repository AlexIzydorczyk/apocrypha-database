class AddDisplayNameToModernSources < ActiveRecord::Migration[7.0]
  def change
    add_column :modern_sources, :display_name, :string, null: false, default: ""
  end
end
