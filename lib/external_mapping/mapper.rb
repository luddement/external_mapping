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

    def create!(external_id=nil)
      external_id = syncer.create! if external_id.nil?
      ExternalMapping::Map.create_mapping(mapped, external_id, external_type)
    end

    def update!(external)
      syncer.update!(external.external_id)
      external.touch
    end

    def find_external(mapped_ids, external_id)
      ExternalMapping::Map.find_external(mapped_type, mapped_ids, external_id, external_type)
    end

    def has_mapping?
      mapping.present?
    end

    def mapping
      @mapping ||= ExternalMapping::Map.find_mapping(mapped, external_type)
    end

    private

    def syncer
      @syncer ||= Syncer.new(external_source, mapped, params)
    end
  end
end
