class RenameFieldsForDates < ActiveRecord::Migration[7.0]
  def change
    rename_column :ownerships, :owner_date_is_approximate, :date_exact
    rename_column :ownerships, :date_for_owner, :specific_date
    rename_column :texts, :date, :specific_date
    add_column :booklists, :date_exact, :boolean, null: false, default: true
  end
end
