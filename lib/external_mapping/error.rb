module ExternalMapping
  class Error < ActiveRecord::Base
    self.table_name = 'external_mapping_errors'

    belongs_to :external_map, class_name: 'ExternalMapping::Map', foreign_key: 'external_mapping_map_id'
  end
end
