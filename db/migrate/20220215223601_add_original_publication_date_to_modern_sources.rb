class AddOriginalPublicationDateToModernSources < ActiveRecord::Migration[7.0]
  def change
    add_column :modern_sources, :original_publication_creation_date, :string, null: false, default: ""
  end
end
