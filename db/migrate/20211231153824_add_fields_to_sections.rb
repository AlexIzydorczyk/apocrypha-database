class AddFieldsToSections < ActiveRecord::Migration[7.0]
  def change
    add_column :sections, :title,                 :string, default: ""
    add_column :sections, :folios_pages_implicit, :string, default: ""
    add_column :sections, :implicit,              :string, default: ""
    add_column :sections, :folios_pages_explicit, :string, default: ""
    add_column :sections, :explicit,              :string, default: ""
  end
end
