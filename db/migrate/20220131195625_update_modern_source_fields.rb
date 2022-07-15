class UpdateModernSourceFields < ActiveRecord::Migration[7.0]
  def change
    add_column :modern_sources, :author_type, :string, null: false, default: ""
    add_reference :modern_sources, :institution, foreign_key: true 
    add_reference :modern_sources, :publication_title_language, foreign_key: {to_table: :languages}
    add_reference :modern_sources, :volume_title_language, foreign_key: {to_table: :languages}
    add_reference :modern_sources, :part_title_language, foreign_key: {to_table: :languages}
    add_reference :modern_sources, :series_title_language, foreign_key: {to_table: :languages}
    add_reference :modern_sources, :title_language, foreign_key: {to_table: :languages}
    add_column :modern_sources, :pages_in_publication, :string, null: false, default: ""
    add_column :modern_sources, :document_type, :string, null: false, default: ""
  end
end
