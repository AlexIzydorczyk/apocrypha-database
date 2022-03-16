class AddWritingSytemToForms < ActiveRecord::Migration[7.0]
  def change
    add_reference :modern_sources, :writing_system, foreign_key: true
    add_reference :texts, :writing_system, foreign_key: true
    remove_reference :locations, :city_orig_language
    remove_reference :locations, :region_orig_language
    remove_reference :locations, :diocese_orig_language
    add_reference :locations, :city_orig_writing_system, foreign_key: { to_table: :writing_systems }
    add_reference :locations, :region_orig_writing_system, foreign_key: { to_table: :writing_systems }
    add_reference :locations, :diocese_orig_writing_system, foreign_key: { to_table: :writing_systems }
    remove_reference :institutions, :language
    add_reference :institutions, :writing_system
    remove_reference :people, :language
    add_reference :people, :writing_system
  end
end
