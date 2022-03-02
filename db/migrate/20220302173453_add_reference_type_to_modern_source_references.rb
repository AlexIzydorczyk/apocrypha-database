class AddReferenceTypeToModernSourceReferences < ActiveRecord::Migration[7.0]
  def change
    add_column :modern_source_references, :reference_type, :string, null: false, default: ""
  end
end
