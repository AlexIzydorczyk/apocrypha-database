class CreateReligiousOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :religious_orders do |t|
      t.string :order_name, null: false, default: ""
      t.timestamps
    end
  end
end
