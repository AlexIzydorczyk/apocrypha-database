class AddHasDetailsToContent < ActiveRecord::Migration[7.0]
  def change
    add_column :contents, :has_details, :boolean, null: false, default: false
  end
end
