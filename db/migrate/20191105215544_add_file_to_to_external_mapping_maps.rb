class AddFileToToExternalMappingMaps < ActiveRecord::Migration
  def change
    add_column :external_mapping_maps, :file_id, :integer
  end
end
