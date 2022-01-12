class CreateInstitutionalAffiliations < ActiveRecord::Migration[7.0]
  def change
    create_table :institutional_affiliations do |t|
      t.references :institution, null: false, foreign_key: true
      t.references :religious_order, foreign_key: true
      t.string :start_date, null: false, default: ""
      t.string :end_date, null: false, default: ""
      t.timestamps
    end
  end
end
