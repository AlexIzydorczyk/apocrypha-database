class AddSpecificDateToManuscriptsAndBooklets < ActiveRecord::Migration[7.0]
  def change
    add_column :manuscripts, :specific_date, :string, null: false, default: ""
    add_column :manuscripts, :date_exact, :boolean, null: false, default: true
    add_column :booklets, :date_exact, :boolean, null: false, default: true
  end
end
