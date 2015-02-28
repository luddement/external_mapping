class ChangeExternalIdToString < ActiveRecord::Migration
  def change
    change_column :external_mapping_maps, :external_id, :string
  end
end
