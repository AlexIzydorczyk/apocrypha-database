class ChangeBookletFolios < ActiveRecord::Migration[7.0]
  def change
    rename_column :booklets, :pages_folios, :pages_folios_from
    add_column :booklets, :pages_folios_to, :string, null: false, default: ""
  end
end
