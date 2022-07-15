class AddReferenceTypeToPersonReference < ActiveRecord::Migration[7.0]
  def change
    add_column :person_references, :reference_type, :string, null: false, default: ""
  end
end
