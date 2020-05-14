class AddDeletedToExternalErrors < ActiveRecord::Migration
  def change
    add_column :external_mapping_errors, :deleted_at, :datetime
  end
end
