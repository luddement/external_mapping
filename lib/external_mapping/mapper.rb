module ExternalMapping
  class Mapper

    attr_reader :external_source, :external_type, :mapped, :mapped_type, :params

    def initialize(external_source, mapped, params={})
      @external_source = external_source
      @external_type = ExternalMapping.sources[external_source.to_sym]
      @mapped = mapped
      @mapped_type = mapped.class == Class ? mapped : mapped.class.name.constantize.base_class
      @params = params
    end

    def sync!
      return unless syncer.can_sync?

      if syncer.respond_to?(:sync!)
        syncer.sync! do
          create_or_update!
        end
      else
        create_or_update!
      end
    end

    def create_or_update!
      if external = ExternalMapping::Map.find_mapping(mapped, external_type)
        update!(external)
      else
        create!
      end
    end

    def create!(external_id=nil, file_id=nil)
      external_id = syncer.create! if external_id.nil?
      ExternalMapping::Map.create_mapping(mapped, external_id, external_type, file_id) if external_id.present?
    end

    def update!(external)
      if syncer.update!(external.external_id)
        external.touch
      end
    end

    def find_external(mapped_ids, external_id)
      ExternalMapping::Map.find_external(mapped_type.name, mapped_ids, external_id, external_type)
    end

    def destroy_mapping!
      ExternalMapping::Map.destroy_mapping(mapped_type.name, mapped.id)
    end

    def has_mapping?
      mapping.present?
    end

    def mapping
      @mapping ||= begin
        if mapped.association(:external_maps).loaded?
          mapped.external_maps.find { |map| map.external_type == external_type }
        else
          ExternalMapping::Map.find_mapping(mapped, external_type)
        end
      end
    end

    private

    def syncer
      @syncer ||= Syncer.build(external_source, mapped, params)
    end
  end
end
