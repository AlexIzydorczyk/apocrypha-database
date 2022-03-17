class AddDateExactToPeople < ActiveRecord::Migration[7.0]
  def change
    add_column :people, :birth_date_exact, :boolean, null: false, default: true
    add_column :people, :death_date_exact, :boolean, null: false, default: true
  end
end
