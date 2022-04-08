class AddReligiousOrderAndNotesToInstitutions < ActiveRecord::Migration[7.0]
  def change
    add_reference :institutions, :religious_order, foreign_key: true
    add_column :institutions, :notes, :text, null: false, default: ""
  end
end
