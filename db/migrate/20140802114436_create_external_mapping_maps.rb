class CreateExternalMappingMaps < ActiveRecord::Migration
  def change
    create_table :external_mapping_maps do |t|
      t.references :mapped, polymorphic: true, null: false
      t.integer :external_type, null: false
      t.integer :external_id, null: false

      t.timestamps
    end

    add_index :external_mapping_maps, [:mapped_type, :mapped_id, :external_type], name: "index_mapped_and_external"
    add_index :external_mapping_maps, [:mapped_type, :mapped_id, :external_id, :external_type], unique: true, name: "index_unique_mapped_and_external"
  end
end
