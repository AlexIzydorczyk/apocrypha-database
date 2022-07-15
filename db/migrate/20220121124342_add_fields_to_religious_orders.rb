class AddFieldsToReligiousOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :religious_orders, :abbreviation, :string, null: false, default: ""
    add_column :religious_orders, :notes, :text, null: false, default: ""
  end
end
