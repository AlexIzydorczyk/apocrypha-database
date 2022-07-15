class CreateChangeLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :change_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :controller_name
      t.string :action_name
      t.references :record, polymorphic: true
      t.string :additional_info, null: false, default: ""
      t.timestamps
    end
  end
end
