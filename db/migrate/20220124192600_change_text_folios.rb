class ChangeTextFolios < ActiveRecord::Migration[7.0]
  def change
    rename_column :texts, :text_pages_folios, :text_pages_folios_from
    add_column :texts, :text_pages_folios_to, :string, null: false, default: ""
    rename_column :texts, :title_folios_pages, :title_pages_folios_from
    add_column :texts, :title_pages_folios_to, :string, null: false, default: ""
    rename_column :texts, :pages_folios_colophon, :colophon_pages_folios_from
    add_column :texts, :colophon_pages_folios_to, :string, null: false, default: ""
  end
end
