class AddReproductionOnlineToManuscripts < ActiveRecord::Migration[7.0]
  def change
    add_column :manuscripts, :reproduction_online, :string, null: false, default: ""
  end
end
