module ExternalMapping
  class Map < ActiveRecord::Base
    self.table_name = 'external_mapping_maps'

    belongs_to :mapped, polymorphic: true
    has_many :external_errors, class_name: 'ExternalMapping::Error', foreign_key: 'external_mapping_map_id', dependent: :destroy

    validates :mapped, :external_id, :external_type, presence: true

    class << self
      def find_mapping(mapped, external_type)
        self.find_by(mapped: mapped, external_type: external_type)
      end

      def create_mapping(mapped, external_id, external_type)
        self.create!(mapped: mapped, external_id: external_id, external_type: external_type)
      end

      def find_external(mapped_type, mapped_ids, external_id, external_type)
        self.find_by(mapped_type: mapped_type, mapped_id: mapped_ids, external_id: external_id, external_type: external_type)
      end

      def destroy_mapping(mapped_type, mapped_id)
        self.find_by(mapped_type: mapped_type, mapped_id: mapped_id).try(:destroy)
      end
    end
  end
end
