class AddFieldsToManuscripts < ActiveRecord::Migration[7.0]
  def change
    add_column :manuscripts, :city, :string, default: ""
    add_column :manuscripts, :country, :string, default: ""
    add_column :manuscripts, :repository, :string, default: ""
    add_column :manuscripts, :shelfmark, :string, default: ""
    add_column :manuscripts, :old_shelfmark, :string, default: ""
    add_column :manuscripts, :dimensions, :string, default: ""
    add_column :manuscripts, :num_pages, :string, default: ""
    add_column :manuscripts, :content_type, :string, default: ""

    add_column :manuscripts, :date_from, :integer
    add_column :manuscripts, :date_to, :integer
    add_column :manuscripts, :languages, :string, array: true, default: []
  end
end
