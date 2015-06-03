class ChangeIndexesOnExternalMappingMaps < ActiveRecord::Migration
  def change
    remove_index :external_mapping_maps, name: "index_mapped_and_external"
    remove_index :external_mapping_maps, name: "index_unique_mapped_and_external"

    add_index :external_mapping_maps, [:mapped_type, :mapped_id, :external_type], unique: true, name: "index_unique_mapped_and_external"
  end
end
