class CreateExternalMappingErrors < ActiveRecord::Migration
  def change
    create_table :external_mapping_errors do |t|
      t.references :external_mapping_map, null: false, index: true
      t.string :code
      t.text :message
      t.text :source

      t.timestamps
    end
  end
end
